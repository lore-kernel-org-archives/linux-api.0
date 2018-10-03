From: Jann Horn <jannh@google.com>
Subject: Re: [RFC v2 v2 1/1] ns: add binfmt_misc to the mount namespace
Date: Wed, 3 Oct 2018 21:26:56 +0200
Message-ID: <CAG48ez3OrkmBUyL6pS=bSHL-NzdPP8z-tD6hSDYDGyL_R25XDg@mail.gmail.com>
References: <20181002102054.13245-1-laurent@vivier.eu> <20181002102054.13245-2-laurent@vivier.eu>
 <87o9cbo96j.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87o9cbo96j.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Laurent Vivier <laurent@vivier.eu>, kernel list <linux-kernel@vger.kernel.org>, dima@arista.com, Andrei Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@hansenpartnership.com>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 3, 2018 at 8:07 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Laurent Vivier <laurent@vivier.eu> writes:
> > This patch allows to have a different binftm_misc configuration
> > in each container we mount binfmt_misc filesystem with mount namespace
> > enabled.
> >
> > A container started without the CLONE_NEWNS will use the host binfmt_misc
> > configuration, otherwise the container starts with an empty binfmt_misc
> > interpreters list.
> >
> > For instance, using "unshare" we can start a chroot of an another
> > architecture and configure the binfmt_misc interpreted without being root
> > to run the binaries in this chroot.
>
> A couple of things.
> As has already been mentioned on your previous version anything that
> comes through the filesystem interface needs to lookup up the local
> binfmt context not through current but through file->f_dentry->d_sb.
> AKA the superblock of the mounted filesystem.

Something else: bm_register_write() currently calls into open_exec(),
which uses the credentials of current. That's not really allowed in
this context - but so far, it's not a big deal because only
init-namespace root can reach this code. Before you expose this stuff
to unprivileged userspace, this needs to get fixed; perhaps by
wrapping the open_exec() call in override_creds(file->f_cred) and
revert_creds().
