From: Jann Horn <jannh@google.com>
Subject: Re: [RFC v5 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 9 Oct 2018 15:15:10 +0200
Message-ID: <CAG48ez1g6kHP+2Mhfv6j=8JGeM0RDWunW8xPY-P3yeeVW5gs2Q@mail.gmail.com>
References: <20181009103752.21482-1-laurent@vivier.eu> <20181009103752.21482-2-laurent@vivier.eu>
 <CAG48ez1OVKqRZe6AtTwXSc27AjNF596nt-46J9WPffKu7fNb8Q@mail.gmail.com> <9059ed5a-6a0d-7f4d-7854-48b3ae4cca76@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9059ed5a-6a0d-7f4d-7854-48b3ae4cca76@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>
Cc: kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, dima@arista.com, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, avagin@gmail.com, containers@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 9, 2018 at 3:06 PM Laurent Vivier <laurent@vivier.eu> wrote:
>
> Le 09/10/2018 =C3=A0 14:43, Jann Horn a =C3=A9crit :
> > On Tue, Oct 9, 2018 at 12:38 PM Laurent Vivier <laurent@vivier.eu> wrot=
e:
> >> This patch allows to have a different binfmt_misc configuration
> >> for each new user namespace. By default, the binfmt_misc configuration
> >> is the one of the previous level, but if the binfmt_misc filesystem is
> >> mounted in the new namespace a new empty binfmt instance is created an=
d
> >> used in this namespace.
> >>
> >> For instance, using "unshare" we can start a chroot of an another
> >> architecture and configure the binfmt_misc interpreter without being r=
oot
> >> to run the binaries in this chroot.
> > [...]
> >> @@ -823,12 +847,34 @@ static const struct super_operations s_ops =3D {
> >>  static int bm_fill_super(struct super_block *sb, void *data, int sile=
nt)
> >>  {
> >>         int err;
> >> +       struct user_namespace *ns =3D sb->s_user_ns;
> >>         static const struct tree_descr bm_files[] =3D {
> >>                 [2] =3D {"status", &bm_status_operations, S_IWUSR|S_IR=
UGO},
> >>                 [3] =3D {"register", &bm_register_operations, S_IWUSR}=
,
> >>                 /* last one */ {""}
> >>         };
> >>
> >> +       /* create a new binfmt namespace
> >> +        * if we are not in the first user namespace
> >> +        * but the binfmt namespace is the first one
> >> +        */
> >> +       if (READ_ONCE(ns->binfmt_ns) =3D=3D NULL) {
> >> +               struct binfmt_namespace *new_ns;
> >> +
> >> +               new_ns =3D kmalloc(sizeof(struct binfmt_namespace),
> >> +                                GFP_KERNEL);
> >> +               if (new_ns =3D=3D NULL)
> >> +                       return -ENOMEM;
> >> +               INIT_LIST_HEAD(&new_ns->entries);
> >> +               new_ns->enabled =3D 1;
> >> +               rwlock_init(&new_ns->entries_lock);
> >> +               new_ns->bm_mnt =3D NULL;
> >> +               new_ns->entry_count =3D 0;
> >> +               /* ensure new_ns is completely initialized before shar=
ing it */
> >> +               smp_wmb();
> >> +               WRITE_ONCE(ns->binfmt_ns, new_ns);
> >> +       }
> >
> > You're still not preventing a concurrent race of two mount() calls,
> > right? What prevents two instances of this code block from running
> > concurrently in two different namespaces? I think you want to take
> > some sort of global lock around this.
> >
>
> My guess was we have only one binfmt superblock by user namespace, so as
> we can't have duplicate superblock, we will not have duplicate binfmt_ns
> structure. This function is only called once in the namespace and I
> think the superblock creation is already protected by some kind of lock.

Ah! Nevermind, I missed the mount_ns().
