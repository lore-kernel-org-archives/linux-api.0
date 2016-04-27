From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Tue, 26 Apr 2016 23:39:24 -0500
Message-ID: <20160427043923.GA25140@mail.hallyn.com>
References: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
 <1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
 <CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
 <20160426222627.GA19307@mail.hallyn.com>
 <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Kees Cook (keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org):
> On Tue, Apr 26, 2016 at 3:26 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Kees Cook (keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org):
> >> On Fri, Apr 22, 2016 at 10:26 AM,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> >> >
> >> > This can only be set by root in his own namespace, and will
> >> > only be respected by namespaces with that same root kuid
> >> > mapped as root, or namespaces descended from it.
> >> >
> >> > This allows a simple setxattr to work, allows tar/untar to
> >> > work, and allows us to tar in one namespace and untar in
> >> > another while preserving the capability, without risking
> >> > leaking privilege into a parent namespace.
> >>
> >> The concept seems sensible to me. Various notes below...
> >>
> >> >
> >> > Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> >> > ---
> >> >  include/linux/capability.h      |    5 ++-
> >> >  include/uapi/linux/capability.h |   18 ++++++++
> >> >  include/uapi/linux/xattr.h      |    3 ++
> >> >  security/commoncap.c            |   91 +++++++++++++++++++++++++++++++++++++--
> >> >  4 files changed, 112 insertions(+), 5 deletions(-)
> >> >
> >> > diff --git a/include/linux/capability.h b/include/linux/capability.h
> >> > index 00690ff..cf533ff 100644
> >> > --- a/include/linux/capability.h
> >> > +++ b/include/linux/capability.h
> >> > @@ -13,7 +13,7 @@
> >> >  #define _LINUX_CAPABILITY_H
> >> >
> >> >  #include <uapi/linux/capability.h>
> >> > -
> >> > +#include <linux/uidgid.h>
> >> >
> >> >  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
> >> >  #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
> >> > @@ -31,6 +31,9 @@ struct cpu_vfs_cap_data {
> >> >         kernel_cap_t inheritable;
> >> >  };
> >> >
> >> > +#define NS_CAPS_VERSION(x) (x & 0xFF)
> >> > +#define NS_CAPS_FLAGS(x) ((x >> 8) & 0xFF)
> >> > +
> >> >  #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
> >> >  #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
> >> >
> >> > diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> >> > index 12c37a1..f0b4a66 100644
> >> > --- a/include/uapi/linux/capability.h
> >> > +++ b/include/uapi/linux/capability.h
> >> > @@ -62,6 +62,9 @@ typedef struct __user_cap_data_struct {
> >> >  #define VFS_CAP_U32_2           2
> >> >  #define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
> >> >
> >> > +/* version number for security.nscapability xattrs hdr->hdr_info */
> >> > +#define VFS_NS_CAP_REVISION     1
> >> > +
> >> >  #define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
> >> >  #define VFS_CAP_U32             VFS_CAP_U32_2
> >> >  #define VFS_CAP_REVISION       VFS_CAP_REVISION_2
> >> > @@ -74,6 +77,21 @@ struct vfs_cap_data {
> >> >         } data[VFS_CAP_U32];
> >> >  };
> >> >
> >> > +#define VFS_NS_CAP_EFFECTIVE    0x1
> >> > +/*
> >> > + * 32-bit hdr_info contains
> >> > + * 16 leftmost: reserved
> >> > + * next 8: flags (only VFS_NS_CAP_EFFECTIVE so far)
> >> > + * last 8: version
> >> > + */
> >> > +struct vfs_ns_cap_data {
> >> > +       __le32 magic_etc;
> >> > +       struct {
> >> > +               __le32 permitted;    /* Little endian */
> >> > +               __le32 inheritable;  /* Little endian */
> >> > +       } data[VFS_CAP_U32];
> >> > +};
> >>
> >> This is identical to vfs_cap_data. Is there a reason not to re-use the
> >> existing one?
> >
> > Hm.  I used to have them completely different.  ATM the only difference
> > is what goes into the magic_etc, and that not very (different).  So
> > yeah it probably should be re-used.
> >
> >> > +
> >> >  #ifndef __KERNEL__
> >> >
> >> >  /*
> >> > diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
> >> > index 1590c49..67c80ab 100644
> >> > --- a/include/uapi/linux/xattr.h
> >> > +++ b/include/uapi/linux/xattr.h
> >> > @@ -68,6 +68,9 @@
> >> >  #define XATTR_CAPS_SUFFIX "capability"
> >> >  #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> >> >
> >> > +#define XATTR_NS_CAPS_SUFFIX "nscapability"
> >> > +#define XATTR_NAME_NS_CAPS XATTR_SECURITY_PREFIX XATTR_NS_CAPS_SUFFIX
> >> > +
> >> >  #define XATTR_POSIX_ACL_ACCESS  "posix_acl_access"
> >> >  #define XATTR_NAME_POSIX_ACL_ACCESS XATTR_SYSTEM_PREFIX XATTR_POSIX_ACL_ACCESS
> >> >  #define XATTR_POSIX_ACL_DEFAULT  "posix_acl_default"
> >>
> >> Are these documented anywhere in Documentation/ or in man pages? This
> >> seems like it'd need a man-page update too.
> >
> > Yeah, if we decide we're ok with this strategy I'll update those.
> >
> >> > diff --git a/security/commoncap.c b/security/commoncap.c
> >> > index 48071ed..8f3f34a 100644
> >> > --- a/security/commoncap.c
> >> > +++ b/security/commoncap.c
> >> > @@ -313,6 +313,10 @@ int cap_inode_need_killpriv(struct dentry *dentry)
> >> >         if (!inode->i_op->getxattr)
> >> >                return 0;
> >> >
> >> > +       error = inode->i_op->getxattr(dentry, XATTR_NAME_NS_CAPS, NULL, 0);
> >> > +       if (error > 0)
> >> > +               return 1;
> >> > +
> >> >         error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
> >> >         if (error <= 0)
> >> >                 return 0;
> >>
> >> I think this might be more readable if the getxattr calls were
> >> standardized (one returns 1, the other returns 0, with inverted tests
> >> -- hard to read). IIUC, if either returns > 0, return 1, otherwise
> >> return 0.
> >
> > Hm.  Yeah I can see where that would be confusing.  I can change the flow
> > to make the checks the same.
> >
> >> > @@ -330,11 +334,17 @@ int cap_inode_need_killpriv(struct dentry *dentry)
> >> >  int cap_inode_killpriv(struct dentry *dentry)
> >> >  {
> >> >         struct inode *inode = d_backing_inode(dentry);
> >> > +       int ret1, ret2;
> >> >
> >> >         if (!inode->i_op->removexattr)
> >> >                return 0;
> >> >
> >> > -       return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
> >> > +       ret1 = inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
> >> > +       ret2 = inode->i_op->removexattr(dentry, XATTR_NAME_NS_CAPS);
> >> > +
> >> > +       if (ret1 != 0)
> >> > +               return ret1;
> >> > +       return ret2;
> >> >  }
> >> >
> >> >  /*
> >> > @@ -438,6 +448,65 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
> >> >         return 0;
> >> >  }
> >> >
> >> > +int get_vfs_ns_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
> >> > +{
> >> > +       struct inode *inode = d_backing_inode(dentry);
> >> > +       unsigned i;
> >> > +       u32 magic_etc;
> >> > +       ssize_t size;
> >> > +       struct vfs_ns_cap_data nscap;
> >> > +       bool foundroot = false;
> >> > +       struct user_namespace *ns;
> >> > +
> >> > +       memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
> >> > +
> >> > +       if (!inode || !inode->i_op->getxattr)
> >> > +               return -ENODATA;
> >> > +
> >> > +       /* verify that current or ancestor userns root owns this file */
> >> > +       for (ns = current_user_ns(); ; ns = ns->parent) {
> >> > +               if (from_kuid(ns, dentry->d_inode->i_uid) == 0) {
> >> > +                       foundroot = true;
> >> > +                       break;
> >> > +               }
> >> > +               if (ns == &init_user_ns)
> >> > +                       break;
> >> > +       }
> >> > +       if (!foundroot)
> >> > +               return -ENODATA;
> >> > +
> >> > +       size = inode->i_op->getxattr((struct dentry *)dentry, XATTR_NAME_NS_CAPS,
> >> > +                       &nscap, sizeof(nscap));
> >> > +       if (size == -ENODATA || size == -EOPNOTSUPP)
> >> > +               /* no data, that's ok */
> >> > +               return -ENODATA;
> >> > +       if (size < 0)
> >> > +               return size;
> >> > +       if (size != sizeof(nscap))
> >> > +               return -EINVAL;
> >> > +
> >> > +       magic_etc = le32_to_cpu(nscap.magic_etc);
> >> > +
> >> > +       if (NS_CAPS_VERSION(magic_etc) != VFS_NS_CAP_REVISION)
> >> > +               return -EINVAL;
> >> > +
> >> > +       cpu_caps->magic_etc = VFS_CAP_REVISION_2;
> >> > +       if (NS_CAPS_FLAGS(magic_etc) & VFS_NS_CAP_EFFECTIVE)
> >> > +               cpu_caps->magic_etc |= VFS_CAP_FLAGS_EFFECTIVE;
> >> > +       /* copy the entry */
> >> > +       CAP_FOR_EACH_U32(i) {
> >> > +               if (i >= VFS_CAP_U32_2)
> >> > +                       break;
> >> > +               cpu_caps->permitted.cap[i] = le32_to_cpu(nscap.data[i].permitted);
> >> > +               cpu_caps->inheritable.cap[i] = le32_to_cpu(nscap.data[i].inheritable);
> >> > +       }
> >> > +
> >> > +       cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
> >> > +       cpu_caps->inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
> >> > +
> >> > +       return 0;
> >> > +}
> >> > +
> >> >  /*
> >> >   * Attempt to get the on-exec apply capability sets for an executable file from
> >> >   * its xattrs and, if present, apply them to the proposed credentials being
> >> > @@ -456,11 +525,13 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
> >> >         if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> >> >                 return 0;
> >> >
> >> > -       rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
> >> > +       rc = get_vfs_ns_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
> >> > +       if (rc == -ENODATA)
> >> > +               rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
> >>
> >> So nscaps overrides a "regular" file cap? That might seem worth
> >> mentioning in the change log or somewhere.
> >
> > If it applies, yes.  Now maybe that's not what we want.  Maybe so long as
> > a regular one exists (which must have been set by the init_user_ns admin)
> > we should use it?  I think that makes sense, what do you think?
> 
> I struggle to see why the non-ns fscap should be honored... this is

Mainly because that's how it is right now - if there is a security.capability
then it is honored in all namespaces.  Changing that *could* change the
behavior which some poor schlep is depending on.  And in general we don't
do that.

> effectively fscap stacking, and there's no way that I see for the cap
> to leak "up" to init_user_ns. It only leaks up to nested user_nses...
> but they need to already be priv-equiv. Hmmm.
> 
> I'm CC'ing Jann who like these mind-benders... :)
> 
> >
> > (In either case agreed it should be clearly documented)
> >
> >> >         if (rc < 0) {
> >> >                 if (rc == -EINVAL)
> >> > -                       printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
> >> > -                               __func__, rc, bprm->filename);
> >> > +                       printk(KERN_NOTICE "Invalid argument reading file caps for %s\n",
> >> > +                                       bprm->filename);
> >> >                 else if (rc == -ENODATA)
> >> >                         rc = 0;
> >> >                 goto out;
> >> > @@ -662,6 +733,12 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
> >> >                 return 0;
> >> >         }
> >> >
> >> > +       if (!strcmp(name, XATTR_NAME_NS_CAPS)) {
> >> > +               if (!capable_wrt_inode_uidgid(dentry->d_inode, CAP_SETFCAP))
> >> > +                       return -EPERM;
> >> > +               return 0;
> >> > +       }
> >> > +
> >> >         if (!strncmp(name, XATTR_SECURITY_PREFIX,
> >> >                      sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> >> >             !capable(CAP_SYS_ADMIN))
> >> > @@ -688,6 +765,12 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
> >> >                 return 0;
> >> >         }
> >> >
> >> > +       if (!strcmp(name, XATTR_NAME_NS_CAPS)) {
> >> > +               if (!capable_wrt_inode_uidgid(dentry->d_inode, CAP_SETFCAP))
> >> > +                       return -EPERM;
> >> > +               return 0;
> >> > +       }
> >> > +
> >>
> >> This looks like userspace must knowingly be aware that it is in a
> >> namespace and to DTRT instead of it being translated by the kernel
> >> when setxattr is called under !init_user_ns?
> >
> > Yes - my libcap2 patch checks /proc/self/uid_map to decide that.  If that
> > shows you are in init_user_ns then it uses security.capability, otherwise
> > it uses security.nscapability.
> >
> > I've occasionally considered having the xattr code do the quiet
> > substitution if need be.
> >
> > In fact, much of this structure comes from when I was still trying to
> > do multiple values per xattr.  Given what we're doing here, we could
> > keep the xattr contents exactly the same, just changing the name.
> > So userspace could just get and set security.capability;  if you are
> > in a non-init user_ns, if security.capability is set then you cannot
> > set it;  if security.capability is not set, then the kernel writes
> > security.nscapability instead and returns success.
> >
> > I don't like magic, but this might be just straightforward enough
> > to not be offensive.  Thoughts?
> 
> Yeah, I think it might be better to have the magic in this case, since
> it seems weird to just reject setxattr if a tool didn't realize it was
> in a namespace. I'm not sure -- it is also nice to have an explicit
> API here.
> 
> I would defer to Eric or Michael on that. I keep going back and forth,
> though I suspect it's probably best to do what you already have
> (explicit API).
> 
> -Kees
> 
> >
> >> >         if (!strncmp(name, XATTR_SECURITY_PREFIX,
> >> >                      sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> >> >             !capable(CAP_SYS_ADMIN))
> >> > --
> >> > 1.7.9.5
> >> >
> >>
> >>
> >>
> >> --
> >> Kees Cook
> >> Chrome OS & Brillo Security
> >> _______________________________________________
> >> Containers mailing list
> >> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> >> https://lists.linuxfoundation.org/mailman/listinfo/containers
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS & Brillo Security
