From: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Tue, 16 Jun 2015 13:31:48 +0100
Message-ID: <20150616123148.GB18689@redhat.com>
References: <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org>
 <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail>
 <55676E32.3050006@nod.at>
 <87382gh3uo.fsf@x220.int.ebiederm.org>
 <55677AEF.1090809@nod.at>
 <87iobcfkwx.fsf@x220.int.ebiederm.org>
 <556831CF.9040600@nod.at>
 <87mw0c1x8p.fsf@x220.int.ebiederm.org>
Reply-To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mw0c1x8p.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "libvir-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <libvir-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cedric Bosdonnat <cbosdonnat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 06, 2015 at 01:56:54PM -0500, Eric W. Biederman wrote:
> Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:
> 
> > [CC'ing libvirt-lxc folks]
> >
> > Am 28.05.2015 um 23:32 schrieb Eric W. Biederman:
> >> Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:
> >> 
> >>> Am 28.05.2015 um 21:57 schrieb Eric W. Biederman:
> >>>>> FWIW, it breaks also libvirt-lxc:
> >>>>> Error: internal error: guest failed to start: Failed to re-mount /proc/sys on /proc/sys flags=1021: Operation not permitted
> >>>>
> >>>> Interesting.  I had not anticipated a failure there?  And it is failing
> >>>> in remount?  Oh that is interesting.
> >>>>
> >>>> That implies that there is some flag of the original mount of /proc that
> >>>> the remount of /proc/sys is clearing, and that previously 
> >>>>
> >>>> The flags specified are current rdonly,remount,bind so I expect there
> >>>> are some other flags on proc that libvirt-lxc is clearing by accident
> >>>> and we did not fail before because the kernel was not enforcing things.
> >>>
> >>> Please see:
> >>> http://libvirt.org/git/?p=libvirt.git;a=blob;f=src/lxc/lxc_container.c;h=9a9ae5c2aaf0f90ff472f24fda43c077b44998c7;hb=HEAD#l933
> >>> lxcContainerMountBasicFS()
> >>>
> >>> and:
> >>> http://libvirt.org/git/?p=libvirt.git;a=blob;f=src/lxc/lxc_container.c;h=9a9ae5c2aaf0f90ff472f24fda43c077b44998c7;hb=HEAD#l850
> >>> lxcBasicMounts
> >>>
> >>>> What are the mount flags in a working libvirt-lxc?
> >>>
> >>> See:
> >>> test1:~ # cat /proc/self/mountinfo
> >>> 149 147 0:56 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
> >>> 150 149 0:56 /sys /proc/sys ro,nodev,relatime - proc proc rw
> >> 
> >>> If you need more info, please let me know. :-)
> >> 
> >> Oh interesting I had not realized libvirt-lxc had grown an unprivileged
> >> mode using user namespaces.
> >> 
> >> This does appear to be a classic remount bug, where you are not
> >> preserving the permissions.  It appears the fact that the code
> >> failed to enforce locked permissions on the fresh mount of proc
> >> was hiding this bug until now.
> >> 
> >> I expect what you actually want is the code below:
> >> 
> >> diff --git a/src/lxc/lxc_container.c b/src/lxc/lxc_container.c
> >> index 9a9ae5c2aaf0..f008a7484bfe 100644
> >> --- a/src/lxc/lxc_container.c
> >> +++ b/src/lxc/lxc_container.c
> >> @@ -850,7 +850,7 @@ typedef struct {
> >>  
> >>  static const virLXCBasicMountInfo lxcBasicMounts[] = {
> >>      { "proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, false, false, false },
> >> -    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_RDONLY, false, false, false },
> >> +    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_RDONLY, false, false, false },
> >>      { "/.oldroot/proc/sys/net/ipv4", "/proc/sys/net/ipv4", NULL, MS_BIND, false, false, true },
> >>      { "/.oldroot/proc/sys/net/ipv6", "/proc/sys/net/ipv6", NULL, MS_BIND, false, false, true },
> >>      { "sysfs", "/sys", "sysfs", MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_RDONLY, false, false, false },
> >> 
> >> Or possibly just:
> >> 
> >> diff --git a/src/lxc/lxc_container.c b/src/lxc/lxc_container.c
> >> index 9a9ae5c2aaf0..a60ccbd12bfc 100644
> >> --- a/src/lxc/lxc_container.c
> >> +++ b/src/lxc/lxc_container.c
> >> @@ -850,7 +850,7 @@ typedef struct {
> >>  
> >>  static const virLXCBasicMountInfo lxcBasicMounts[] = {
> >>      { "proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, false, false, false },
> >> -    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_RDONLY, false, false, false },
> >> +    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_RDONLY, true, false, false },
> >>      { "/.oldroot/proc/sys/net/ipv4", "/proc/sys/net/ipv4", NULL, MS_BIND, false, false, true },
> >>      { "/.oldroot/proc/sys/net/ipv6", "/proc/sys/net/ipv6", NULL, MS_BIND, false, false, true },
> >>      { "sysfs", "/sys", "sysfs", MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_RDONLY, false, false, false },
> >> 
> >> As the there is little point in making /proc/sys read-only in a
> >> user-namespace, as the permission checks are uid based and no-one should
> >> have the global uid 0 in your container.  Making mounting /proc/sys
> >> read-only rather pointless.
> >
> > Eric, using the patch below I was able to spawn a user-namespace enabled container
> > using libvirt-lxc. :-)
> >
> > I had to:
> > 1. Disable the read-only mount of /proc/sys which is anyway useless in the user-namespace case.
> > 2. Disable the /proc/sys/net/ipv{4,6} bind mounts, this ugly hack is only needed for the non user-namespace case.
> > 3. Remove MS_RDONLY from the sysfs mount (For the non user-namespace case we'd have to keep this, though).
> >
> > Daniel, I'd take this as a chance to disable all the MS_RDONLY games if user-namespace are configured.
> > With Eric's fixes they hurt us. And as I wrote many times before if root within the user-namespace
> > is able to do nasty things in /sys and /proc that's a plain kernel bug which needs fixing. There is no
> > point in mounting these read-only. Except for the case then no user-namespace is used.
> >
> 
> For clarity the patch below appears to be the minimal change needed to
> fix this security issue.
> 
> AKA add mnt_mflags in when remounting something read-only.
> 
> /proc/sys needed to be updated so it had the proper flags to be added
> back in.
> 
> I hope this helps.
> 
> diff --git a/src/lxc/lxc_container.c b/src/lxc/lxc_container.c
> index 9a9ae5c2aaf0..11e9514e0761 100644
> --- a/src/lxc/lxc_container.c
> +++ b/src/lxc/lxc_container.c
> @@ -850,7 +850,7 @@ typedef struct {
>  
>  static const virLXCBasicMountInfo lxcBasicMounts[] = {
>      { "proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, false, false, false },
> -    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_RDONLY, false, false, false },
> +    { "/proc/sys", "/proc/sys", NULL, MS_BIND|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_RDONLY, false, false, false },
>      { "/.oldroot/proc/sys/net/ipv4", "/proc/sys/net/ipv4", NULL, MS_BIND, false, false, true },
>      { "/.oldroot/proc/sys/net/ipv6", "/proc/sys/net/ipv6", NULL, MS_BIND, false, false, true },
>      { "sysfs", "/sys", "sysfs", MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_RDONLY, false, false, false },
> @@ -1030,7 +1030,7 @@ static int lxcContainerMountBasicFS(bool userns_enabled,
>  
>          if (bindOverReadonly &&
>              mount(mnt_src, mnt->dst, NULL,
> -                  MS_BIND|MS_REMOUNT|MS_RDONLY, NULL) < 0) {
> +                  MS_BIND|MS_REMOUNT|mnt_mflags|MS_RDONLY, NULL) < 0) {
>              virReportSystemError(errno,
>                                   _("Failed to re-mount %s on %s flags=%x"),
>                                   mnt_src, mnt->dst,

Thanks Richard / Eric for the suggested patches. I'll apply Eric's
simplified patch to libvirt now, and backport it to our stable
libvirt branches.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
