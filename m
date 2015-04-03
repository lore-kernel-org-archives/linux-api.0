From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Fri, 03 Apr 2015 08:42:39 -0400
Message-ID: <18079199.sKrYvVCScd@x2>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
	<CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: linux-audit@redhat.com
Cc: roy.qing.li@gmail.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday, March 20, 2015 09:29:14 AM Paul Moore wrote:
> On Fri, Mar 20, 2015 at 12:55 AM,  <roy.qing.li@gmail.com> wrote:
> > From: Li RongQing <roy.qing.li@gmail.com>
> > 
> > After 2f9783669 [ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless
> > of endianness], no kernel user uses this macro;
> > 
> > Keeping this macro, only makes the compiling old version audit [before
> > changeset 931 Improve ARM and AARCH64 support] success, but the audit
> > program can not work with the kernel after 2f9783669 still,
> > since no syscall entry is enabled for AUDIT_ARCH_ARMEB in kernel.
> > 
> > so remove it to force to use the latest audit program
> > 
> > Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
> > ---
> > other workaround is to define AUDIT_ARCH_ARMEB as AUDIT_ARCH_ARM,
> > but it seems very strange
> > 
> >  include/uapi/linux/audit.h | 1 -
> >  1 file changed, 1 deletion(-)
> 
> Since this #define lives in the user visible headers I don't want to
> remove it and risk causing a userspace breakage.  Leaving the #define
> in the header, even if it is unused by modern userspace, is harmless.

This macro doesn't appear to be in use by auditd.

-Steve

> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index d3475e1..125aa49 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -351,7 +351,6 @@ enum {
> > 
> >  #define AUDIT_ARCH_AARCH64    
> >  (EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE) #define AUDIT_ARCH_ALPHA
> >        (EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE) #define
> >  AUDIT_ARCH_ARM         (EM_ARM|__AUDIT_ARCH_LE)
> > 
> > -#define AUDIT_ARCH_ARMEB       (EM_ARM)
> > 
> >  #define AUDIT_ARCH_CRIS                (EM_CRIS|__AUDIT_ARCH_LE)
> >  #define AUDIT_ARCH_FRV         (EM_FRV)
> >  #define AUDIT_ARCH_I386                (EM_386|__AUDIT_ARCH_LE)
> > 
> > --
> > 2.1.0
