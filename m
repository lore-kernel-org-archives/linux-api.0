From: Daniel Mack <daniel@zonque.org>
Subject: Re: [RFC 2/8] lsm: smack: Make ipc/kdbus includes visible so smack
 callbacks could see them
Date: Wed, 8 Jul 2015 12:43:53 -0400
Message-ID: <559D5349.50409@zonque.org>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-3-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436351110-5902-3-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>, Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

On 07/08/2015 06:25 AM, Paul Osmialowski wrote:
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  security/smack/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/security/smack/Makefile b/security/smack/Makefile
> index ee2ebd5..bd6927c 100644
> --- a/security/smack/Makefile
> +++ b/security/smack/Makefile
> @@ -6,3 +6,5 @@ obj-$(CONFIG_SECURITY_SMACK) := smack.o
>  
>  smack-y := smack_lsm.o smack_access.o smackfs.o
>  smack-$(CONFIG_SECURITY_SMACK_NETFILTER) += smack_netfilter.o
> +
> +ccflags-y += -Iipc
> 

I would really like to avoid exposing the internal structures of kdbus
to LSM modules. This is going to get messy if any internals change in
the future.

The callbacks for smack currently only use the passed structure to
access the opaque 'security' pointer. Can't you just pass that directly
(as void**), along with other parameters the LSMs needs to know about?


Thanks,
Daniel
