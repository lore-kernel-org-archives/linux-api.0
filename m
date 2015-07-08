From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC 5/8] kdbus: use LSM hooks in kdbus code
Date: Wed, 08 Jul 2015 09:37:47 -0400
Message-ID: <559D27AB.4010402@tycho.nsa.gov>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com> <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>, Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

On 07/08/2015 06:25 AM, Paul Osmialowski wrote:
> Originates from:
> 
> https://github.com/lmctl/kdbus.git (branch: kdbus-lsm-v4.for-systemd-v212)
> commit: aa0885489d19be92fa41c6f0a71df28763228a40
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  ipc/kdbus/bus.c        | 12 ++++++++++-
>  ipc/kdbus/bus.h        |  3 +++
>  ipc/kdbus/connection.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  ipc/kdbus/connection.h |  4 ++++
>  ipc/kdbus/domain.c     |  9 ++++++++-
>  ipc/kdbus/domain.h     |  2 ++
>  ipc/kdbus/endpoint.c   | 11 ++++++++++
>  ipc/kdbus/names.c      | 11 ++++++++++
>  ipc/kdbus/queue.c      | 30 ++++++++++++++++++----------
>  9 files changed, 124 insertions(+), 12 deletions(-)
> 
>

> diff --git a/ipc/kdbus/connection.c b/ipc/kdbus/connection.c
> index 9993753..b85cdc7 100644
> --- a/ipc/kdbus/connection.c
> +++ b/ipc/kdbus/connection.c
> @@ -31,6 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
>  
>  #include "bus.h"
>  #include "connection.h"
> @@ -73,6 +74,8 @@ static struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep, bool privileged,
>  	bool is_activator;
>  	bool is_monitor;
>  	struct kvec kvec;
> +	u32 sid, len;
> +	char *label;
>  	int ret;
>  
>  	struct {
> @@ -222,6 +225,14 @@ static struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep, bool privileged,
>  		}
>  	}
>  
> +	security_task_getsecid(current, &sid);
> +	security_secid_to_secctx(sid, &label, &len);
> +	ret = security_kdbus_connect(conn, label, len);
> +	if (ret) {
> +		ret = -EPERM;
> +		goto exit_unref;
> +	}

This seems convoluted and expensive.  If you always want the label of
the current task here, then why not just have security_kdbus_connect()
internally extract the label of the current task?

> @@ -1107,6 +1119,12 @@ static int kdbus_conn_reply(struct kdbus_conn *src, struct kdbus_kmsg *kmsg)
>  	if (ret < 0)
>  		goto exit;
>  
> +	ret = security_kdbus_talk(src, dst);
> +	if (ret) {
> +		ret = -EPERM;
> +		goto exit;
> +	}

Where does kdbus apply its uid-based or other restrictions on
connections?  Why do we need to insert separate hooks into each of these
functions?  Is there no central chokepoint already for permission
checking that we can hook?

> diff --git a/ipc/kdbus/connection.h b/ipc/kdbus/connection.h
> index d1ffe90..1f91d39 100644
> --- a/ipc/kdbus/connection.h
> +++ b/ipc/kdbus/connection.h
> @@ -19,6 +19,7 @@
>  #include <linux/kref.h>
>  #include <linux/lockdep.h>
>  #include <linux/path.h>
> +#include <uapi/linux/kdbus.h>
>  
>  #include "limits.h"
>  #include "metadata.h"
> @@ -73,6 +74,7 @@ struct kdbus_kmsg;
>   * @names_queue_list:	Well-known names this connection waits for
>   * @privileged:		Whether this connection is privileged on the bus
>   * @faked_meta:		Whether the metadata was faked on HELLO
> + * @security:		LSM security blob
>   */
>  struct kdbus_conn {
>  	struct kref kref;
> @@ -113,6 +115,8 @@ struct kdbus_conn {
>  
>  	bool privileged:1;
>  	bool faked_meta:1;
> +
> +	void *security;
>  };

Unless I missed it, you may have missed the most important thing of all:
 controlling kdbus's notion of "privileged".  kdbus sets privileged to
true if the process has CAP_IPC_OWNER or the process euid matches the
uid of the bus creator, and then it allows those processes to do many
dangerous things, including monitoring all traffic, impersonating
credentials, pids, or seclabel, etc.

I don't believe we should ever permit impersonating seclabel information.
