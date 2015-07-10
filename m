From: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Subject: Re: [RFC 5/8] kdbus: use LSM hooks in kdbus code
Date: Fri, 10 Jul 2015 12:56:00 -0400
Message-ID: <559FF920.2020302@tycho.nsa.gov>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com> <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com> <559D27AB.4010402@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559D27AB.4010402-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/08/2015 09:37 AM, Stephen Smalley wrote:
> On 07/08/2015 06:25 AM, Paul Osmialowski wrote:
>> Originates from:
>>
>> https://github.com/lmctl/kdbus.git (branch: kdbus-lsm-v4.for-systemd-v212)
>> commit: aa0885489d19be92fa41c6f0a71df28763228a40
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  ipc/kdbus/bus.c        | 12 ++++++++++-
>>  ipc/kdbus/bus.h        |  3 +++
>>  ipc/kdbus/connection.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  ipc/kdbus/connection.h |  4 ++++
>>  ipc/kdbus/domain.c     |  9 ++++++++-
>>  ipc/kdbus/domain.h     |  2 ++
>>  ipc/kdbus/endpoint.c   | 11 ++++++++++
>>  ipc/kdbus/names.c      | 11 ++++++++++
>>  ipc/kdbus/queue.c      | 30 ++++++++++++++++++----------
>>  9 files changed, 124 insertions(+), 12 deletions(-)
>>
>>
> 
>> diff --git a/ipc/kdbus/connection.c b/ipc/kdbus/connection.c
>> index 9993753..b85cdc7 100644
>> --- a/ipc/kdbus/connection.c
>> +++ b/ipc/kdbus/connection.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/syscalls.h>
>>  #include <linux/uio.h>
>> +#include <linux/security.h>
>>  
>>  #include "bus.h"
>>  #include "connection.h"
>> @@ -73,6 +74,8 @@ static struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep, bool privileged,
>>  	bool is_activator;
>>  	bool is_monitor;
>>  	struct kvec kvec;
>> +	u32 sid, len;
>> +	char *label;
>>  	int ret;
>>  
>>  	struct {
>> @@ -222,6 +225,14 @@ static struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep, bool privileged,
>>  		}
>>  	}
>>  
>> +	security_task_getsecid(current, &sid);
>> +	security_secid_to_secctx(sid, &label, &len);
>> +	ret = security_kdbus_connect(conn, label, len);
>> +	if (ret) {
>> +		ret = -EPERM;
>> +		goto exit_unref;
>> +	}
> 
> This seems convoluted and expensive.  If you always want the label of
> the current task here, then why not just have security_kdbus_connect()
> internally extract the label of the current task?
> 
>> @@ -1107,6 +1119,12 @@ static int kdbus_conn_reply(struct kdbus_conn *src, struct kdbus_kmsg *kmsg)
>>  	if (ret < 0)
>>  		goto exit;
>>  
>> +	ret = security_kdbus_talk(src, dst);
>> +	if (ret) {
>> +		ret = -EPERM;
>> +		goto exit;
>> +	}
> 
> Where does kdbus apply its uid-based or other restrictions on
> connections?  Why do we need to insert separate hooks into each of these
> functions?  Is there no central chokepoint already for permission
> checking that we can hook?

For example, why wouldn't you insert a single hook into
kdbus_conn_policy_talk() where they perform their DAC checking?
You would need to restructure it slightly to ensure that the security
hook is only called if it passes the DAC (privileged || uid_eq) check so
that we do not trigger MAC denials when DAC wouldn't have allowed it
anyway.  Also, kdbus_conn_policy_talk() takes a separate conn_creds
argument - that should be passed through to the hook as well.
