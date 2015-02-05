From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC] Implement ambient capability set.
Date: Thu, 5 Feb 2015 08:20:16 +0100
Message-ID: <CAHO5Pa2Lg3EAS8GU5233J3dgQaWuVr0jNfDdEMqatFAG3KEMpQ@mail.gmail.com>
References: <alpine.DEB.2.11.1502041242380.17411@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1502041242380.17411@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Andrew G. Morgan" <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]

Christoph,

Since this is a kernel-user-space API change, please CC linux-api@.
The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api@vger.kernel.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael


On Wed, Feb 4, 2015 at 7:49 PM, Christoph Lameter <cl@linux.com> wrote:
> An attempt to implement this. Probably missing some fine points:
>
> Subject: [capabilities] Implement ambient capability set.
>
> DRAFT -- untested -- DRAFT
>
> Implement an ambient capabilty set to allow capabilties
> to be inherited with unix semantics used also for other
> attributes.
>
> Implements PR_CAP_AMBIENT. The second argument to prctl
> is a the capability number and the third the desired state.
> 0 for off. Otherwise on.
>
> Serge:
> A new capability set, pA, is empty by default.  You can
> add bits to it using prctl if ns_capable(CAP_SETPCAP) and
> all the new bits are in your pE.  Once set, they stay until
> they are removed using prctl.  At exec, pA' = pA, and
> fI |= pA (after reading fI from disk but before
> calculating pI').
>
> Since the ambient caps "stay on" cap_inheritable does not
> really matter anymore. Simply set the permitted caps when
> the ambient cap is set.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Index: linux/security/commoncap.c
> ===================================================================
> --- linux.orig/security/commoncap.c     2015-02-04 09:44:25.000000000 -0600
> +++ linux/security/commoncap.c  2015-02-04 12:48:44.100471600 -0600
> @@ -353,7 +353,7 @@ static inline int bprm_caps_from_vfs_cap
>                 /*
>                  * pP' = (X & fP) | (pI & fI)
>                  */
> -               new->cap_permitted.cap[i] =
> +               new->cap_permitted.cap[i] = current_cred()->cap_ambient.cap[i] |
>                         (new->cap_bset.cap[i] & permitted) |
>                         (new->cap_inheritable.cap[i] & inheritable);
>
> @@ -577,6 +577,7 @@ skip:
>         }
>
>         new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
> +       new->cap_ambient = old->cap_ambient;
>         return 0;
>  }
>
> @@ -933,6 +934,20 @@ int cap_task_prctl(int option, unsigned
>                         new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
>                 return commit_creds(new);
>
> +       case PR_CAP_AMBIENT:
> +               if (!ns_capable(current_user_ns(), CAP_SETPCAP))
> +                       return -EPERM;
> +
> +               if (!cap_valid(arg2))
> +                       return -EINVAL;
> +
> +               new =prepare_creds();
> +               if (arg3 == 0)
> +                       cap_lower(new->cap_ambient, arg2);
> +               else
> +                       cap_raise(new->cap_ambient, arg2);
> +               return commit_creds(new);
> +
>         default:
>                 /* No functionality available - continue with default */
>                 return -ENOSYS;
> Index: linux/include/linux/cred.h
> ===================================================================
> --- linux.orig/include/linux/cred.h     2015-02-04 09:39:46.000000000 -0600
> +++ linux/include/linux/cred.h  2015-02-04 12:32:43.719846530 -0600
> @@ -122,6 +122,7 @@ struct cred {
>         kernel_cap_t    cap_permitted;  /* caps we're permitted */
>         kernel_cap_t    cap_effective;  /* caps we can actually use */
>         kernel_cap_t    cap_bset;       /* capability bounding set */
> +       kernel_cap_t    cap_ambient;    /* Ambient capability set */
>  #ifdef CONFIG_KEYS
>         unsigned char   jit_keyring;    /* default keyring to attach requested
>                                          * keys to */
> Index: linux/include/uapi/linux/prctl.h
> ===================================================================
> --- linux.orig/include/uapi/linux/prctl.h       2014-12-12 10:27:49.332800377 -0600
> +++ linux/include/uapi/linux/prctl.h    2015-02-04 12:39:10.651205059 -0600
> @@ -185,4 +185,7 @@ struct prctl_mm_map {
>  #define PR_MPX_ENABLE_MANAGEMENT  43
>  #define PR_MPX_DISABLE_MANAGEMENT 44
>
> +/* Control the ambient capability set */
> +#define PR_CAP_AMBIENT 45
> +
>  #endif /* _LINUX_PRCTL_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
