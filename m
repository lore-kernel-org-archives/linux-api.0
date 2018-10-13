From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock
 for reconfiguration [ver #12]
Date: Sat, 13 Oct 2018 16:04:09 -0700
Message-ID: <CALCETrWvEJHGWNXvOBcaFbX16pyBEqmNk4V+dBxX00OAS4OMng@mail.gmail.com>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
 <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk>
 <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com> <20181013061141.GR32577@ZenIV.linux.org.uk>
 <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: alan.christopher.jenkins@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 13, 2018 at 2:45 AM Alan Jenkins
<alan.christopher.jenkins@gmail.com> wrote:
>
> On 13/10/2018 07:11, Al Viro wrote:
> > On Fri, Oct 12, 2018 at 03:49:50PM +0100, Alan Jenkins wrote:
> >>> +SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags)
> >>> +{
> >>> +   struct fs_context *fc;
> >>> +   struct path target;
> >>> +   unsigned int lookup_flags;
> >>> +   int ret;
> >>> +
> >>> +   if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
> >>> +           return -EPERM;
> >>
> >> This seems to accept basically any mount.  Specifically: are you sure it's
> >> OK to return a handle to a SB_NO_USER superblock?
> > Umm...  As long as we don't try to do pathname resolution from its ->s_root,
> > shouldn't be a problem and I don't see anything that would do that.  I might've
> > missed something, but...
>
> Sorry, I guess SB_NOUSER was the wrong word.  I was trying find if
> anything stopped things like
>
> int memfd = memfd_create("foo", 0);
> int fsfd = fspick(memfd, "", FSPICK_EMPTY_PATH);
>
> fsconfig(fsfd, FSCONFIG_SET_FLAG, "ro", NULL, 0);
> fsconfig(fsfd, FSCONFIG_SET_STRING, "size", "100M", 0);
> fsconfig(fsfd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);
>
> So far I'm getting -EBUSY if I try to apply the "ro", -EINVAL if I try
> to apply the "size=100M".  But if I don't apply either, then
> FSCONFIG_CMD_RECONFIGURE succeeds.
>
> It seems worrying that it might let me set options on shm_mnt. Or at
> least letting me get as far as the -EBUSY check for the "ro" superblock
> flag.
>
> I'm not sure why I'm getting the -EINVAL setting the "size" option.  But
> it would be much more reassuring if I was getting -EPERM :-).
>

I would argue that the filesystem associated with a memfd, and even
the fact that there *is* a filesystem, is none of user code's
business.  So that fspick() call should return -EINVAL or similar.
