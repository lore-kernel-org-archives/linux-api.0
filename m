From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
Date: Sat, 17 Dec 2016 22:06:51 +0100
Message-ID: <5855A8EB.8000005@digikod.net>
References: <1481949827-23613-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="fr0scPtoFDiROjB9iNgJDFGQwsmg913AD"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481949827-23613-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Vander Stoep <jeffv-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fr0scPtoFDiROjB9iNgJDFGQwsmg913AD
Content-Type: multipart/mixed; boundary="NT58vVD25oV9ie81jtpVphIDedrpIuwsp";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>,
 Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>,
 Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>,
 Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
 Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>,
 Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>,
 Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Morris
 <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Vander Stoep <jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,
 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Message-ID: <5855A8EB.8000005-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
References: <1481949827-23613-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
In-Reply-To: <1481949827-23613-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

--NT58vVD25oV9ie81jtpVphIDedrpIuwsp
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

If I understand correctly, this patch is intended to add a delegation
feature to cgroup v1, which does not really make sense for the v2
because of the clean cgroup-v2 delegation design. However, this new
capability impact both versions.

As Michael said, capabilities are a limited numbers of silos and we
should try to use existing ones as much as possible but without falling
into the trap of using the same capability for everything (e.g.
CAP_SYS_ADMIN) [1]. The CAP_CGROUP looks a lot like another
CAP_SYS_ADMIN. It is not tied to any particular privilege.

Cgroups are not about resource limitation or any particular access
control, they are just about managing a set of processes, which may then
be subject to resource limitation or access control. This possible
limitations only depend on cgroup controllers or netfilter rules or BPF
programs.

To avoid the current capability issue [1], I think it should be a good
idea to reuse an existing capability (if one make sense) for each class
of constraints a controller/eBPF program/netfilter rule can enforce.
This may looks like CAP_NET_ADMIN (with network namespace handling) for
netfilter and eBPF *socket* programs but CAP_SYS_RESOURCE for the CPU,
memory and IO controllers.
As Tejun said, it will be more complicated to handle such a case, but I
don't see any other solution to keep a meaningful use of capabilities.

However, even if a cgroup does not directly involve a limitation, it may
be used to identify a group of processes for a security critical purpose
(e.g. kill a group of process). It can then make sense to have a
dedicated capability CAP_CGROUP to allow a process *without the right to
write in cgroup.procs* to be allowed to move a process out of its
current cgroup. This is similar to CAP_DAC_OVERRIDE but only for
cgroup/controllers files (but not necessarily sufficient to modify all
cgroups). This does not means that CAP_CGROUP should allow to move any
process from any cgroup. The cgroup_procs_write_permission() should
compose the checks for CAP_CGROUP and/or CAP_SYS_RESOURCE and/or
CAP_SYS_ADMIN depending on the current use of the cgroup (i.e. cgroup
controller, BPF program type, netfilter).

Regards,
 Micka=EBl


[1] https://forums.grsecurity.net/viewtopic.php?f=3D7&t=3D2522


On 17/12/2016 05:43, John Stultz wrote:
> This patch adds CAP_GROUP and logic to allows a process to
> migrate other tasks between cgroups.
>=20
> In Android (where this feature originated), the ActivityManager
> tracks various application states (TOP_APP, FOREGROUND,
> BACKGROUND, SYSTEM, etc), and then as applications change
> states, the SchedPolicy logic will migrate the application tasks
> between different cgroups used to control the different
> application states (for example, there is a background cpuset
> cgroup which can limit background tasks to stay on one low-power
> cpu, and the bg_non_interactive cpuctrl cgroup can then further
> limit those background tasks to a small percentage of that one
> cpu's cpu time).
>=20
> However, for security reasons, Android doesn't want to make the
> system_server (the process that runs the ActivityManager and
> SchedPolicy logic), run as root. So in the Android common.git
> kernel, they have some logic to allow cgroups to loosen their
> permissions so CAP_SYS_NICE tasks can migrate other tasks between
> cgroups.
>=20
> I feel the approach taken there overloads CAP_SYS_NICE a bit much
> for non-android environments. Efforts to re-use CAP_SYS_RESOURCE
> for this purpose (which Android has since adopted) was also
> stymied by concerns about risks from future cgroups that could be
> considered "dangerous" by how they might change system semantics.
>=20
> So to avoid overlapping usage, this patch adds a brand new
> process capability flag (CAP_CGROUP), and uses it when checking
> if a task can migrate other tasks between cgroups.
>=20
> I've tested this with AOSP master (though its a bit hacked in as
> I still need to properly get the selinux userspace bits aware of
> the new capability bit) with selinux set to permissive and it
> seems to be working well.
>=20
> Thoughts and feedback would be appreciated!
>=20
> (Note, I'm going on holiday break after today, so I may not
> respond to feedback immediately, but I figured it would be
> better to give folks the chance to review this rather then sit
> it for two weeks. I'll resend after the new-year, addressing any
> feedback I do get.)
>=20
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
> Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
> Cc: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
> Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Jeff Vander Stoep <jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
> Signed-off-by: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2: Renamed to just CAP_CGROUP_MIGRATE as reccomended by Tejun
> v3: Switched to just using CAP_SYS_RESOURCE as suggested by Michael
> v4: Send out properly folded down version of the patch. :P
> v5: Switch back to CAP_CGROUP_MIGRATE due to concerns from Andy
> v6: Rename to CAP_CGROUP, as it might be used for other purposes
>     in the future. Also added selinux mappings for the new cap.
> ---
>  include/uapi/linux/capability.h     | 5 ++++-
>  kernel/cgroup.c                     | 3 ++-
>  security/selinux/include/classmap.h | 4 ++--
>  3 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capab=
ility.h
> index 49bc062..726f767 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -349,8 +349,11 @@ struct vfs_cap_data {
> =20
>  #define CAP_AUDIT_READ		37
> =20
> +/* Allow migration of other tasks between cgroups */
> =20
> -#define CAP_LAST_CAP         CAP_AUDIT_READ
> +#define CAP_CGROUP		38
> +
> +#define CAP_LAST_CAP         CAP_CGROUP
> =20
>  #define cap_valid(x) ((x) >=3D 0 && (x) <=3D CAP_LAST_CAP)
> =20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2ee9ec3..8b42ae3 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2856,7 +2856,8 @@ static int cgroup_procs_write_permission(struct t=
ask_struct *task,
>  	 */
>  	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
>  	    !uid_eq(cred->euid, tcred->uid) &&
> -	    !uid_eq(cred->euid, tcred->suid))
> +	    !uid_eq(cred->euid, tcred->suid) &&
> +	    !ns_capable(tcred->user_ns, CAP_CGROUP))
>  		ret =3D -EACCES;
> =20
>  	if (!ret && cgroup_on_dfl(dst_cgrp)) {
> diff --git a/security/selinux/include/classmap.h b/security/selinux/inc=
lude/classmap.h
> index e2d4ad3a..ee8c1ed 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -22,9 +22,9 @@
>  	    "audit_control", "setfcap"
> =20
>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
> -		"wake_alarm", "block_suspend", "audit_read"
> +		"wake_alarm", "block_suspend", "audit_read", "cgroup"
> =20
> -#if CAP_LAST_CAP > CAP_AUDIT_READ
> +#if CAP_LAST_CAP > CAP_CGROUP
>  #error New capability defined, please update COMMON_CAP2_PERMS.
>  #endif
> =20
>=20



--NT58vVD25oV9ie81jtpVphIDedrpIuwsp--

--fr0scPtoFDiROjB9iNgJDFGQwsmg913AD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlhVqOsACgkQIt7+33O9
apVZ9wf/WwxdzZA+HKnQ5m8eRh8pSIyjYSuhtTxKoln+qYCHtz7U2XrFuFw2d5IH
wxYGQwyItJwAKOivB3zGqCbkWqCp0o/R5+WcvI8nIy5cGQD9Oi5ZWD81iL7YZoRS
PNzmBX9Cy8fBB55m7jI6GzcSvCTqt4wGCfuoMvl9q2SC/fXmQknkFxzdM0z7nIVa
XyfaFI7xcKo3Ig0TCegXbxoVZBXycjfmzbdMt9pxyDCQmXwHY6ajM/GP931wlYyK
1eWYSSVFg2a783ZtLvZTzq3aA5liFx6EqtojGUz2KUBp8NZPEtyK/XPKqsXwFKJL
HvVas04CwrdDiwHKskhzym6aRS2xkA==
=dW2P
-----END PGP SIGNATURE-----

--fr0scPtoFDiROjB9iNgJDFGQwsmg913AD--
