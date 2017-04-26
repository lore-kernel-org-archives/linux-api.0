From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Revised statx(2) man page for review [and AT_EMPTY_PATH question]
Date: Wed, 26 Apr 2017 12:35:08 +0100
Message-ID: <14390.1493206508@warthog.procyon.org.uk>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>        Note: There is no glibc wrapper for renameat2(); see NOTES.

statx, not renameat2.

>                __u64 stx_blocks;      /* Number of 512B blocks allocated */

The following needs to be added in here:

		__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */

This indicates what stx_attributes the VFS and filesystem actually support.

>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec */

If you're going to do Dmitry's suggestion, then this needs to be __u32 and you
should remove "before or".

>        statx() uses pathname, dirfd, and  flags  identify  the  target
>        file in one of the following ways:

"to identify"

>        A pathname interpreted relative to a directory file descriptor

I think this is too wordy for a heading and it almost seems to merge into the
description paragraph since it almost ends at the same right margin.  How
about:

	A directory-relative pathname

>        By file descriptor
>               If pathname is NULL, then the target  file  is  the  one
>               referred  to  by  the  file descriptor dirfd.  dirfd may
>               refer to any type of file, not just a  directory.   (The
>               AT_EMPTY_PATH  flag  described  below  provides  similar
>               functionality.)
> 
>               ┌───────────────────────────────┐
>               │FIXME                                                │
>               ├───────────────────────────────┤
>               │It appears that there  are  two  different  ways  of │
>               │doing  the  same  thing:  specifying  the file to be │
>               │stat'ed via a file descriptor.  Either,  we  specify │
>               │'pathname'  as  NULL, or we specify 'pathname' as an │
>               │empty string and  include  the  AT_EMPTY_PATH  flag. │
>               │What's  the  rationale  for having two ways of doing │
>               │this?                                                │
>               └───────────────────────────────┘

AT_EMPTY_PATH wasn't there back in 2010.  I could eliminate the:

	statx(fd, NULL, 0, ...);

option in favour of:

	statx(fd, "", AT_EMPTY_PATH, ...);

Any thoughts either way, Al?

It would seem that AT_EMPTY_PATH should be redundant, though, since you can
just set the pathname pointer to NULL.

>        The mask argument to statx() is used to tell the  kernel  which
>        fields  the  caller is interested in.  mask is an ORed combina‐
>        tion of the following constants:
> 
>            STATX_TYPE          Want stx_mode & S_IFMT
>	     ...
>            STATX_ALL           [All currently available fields]
> 
>        Note the kernel does not reject values in mask other  than  the
>        above.   Instead, it simply informs the caller which values are
>        supported by this kernel and filesystem via the  statx.stx_mask
>        field.  Therefore, do not simply set mask to UINT_MAX (all bits
>        set), as one or more bits may, in the future, be used to  spec‐
>        ify an extension to the buffer.

Is it worth mentioning STATX__RESERVED here, I wonder?  It's not something
that you can actually use (you'll get EINVAL if you try), and will be renamed
should it become used.

>        It should be noted that  the  kernel  may  return  fields  that
>        weren't  requested  and  may  fail  to  return fields that were
>        requested, depending on what the backing  filesystem  supports.

Maybe add "and can be safely ignored" in there somewhere since this seems to
be upsetting people.

>        If a filesystem does not support a field or if it has an unrep‐
>        resentable value (for instance, a file with  an  exotic  type),
>        then  the  mask bit corresponding to that field will be cleared
>        in stx_mask even if the user asked for it  and  a  dummy  value
>        will  be  filled in for compatibility purposes if one is avail‐
>        able (e.g., a dummy UID and GID may be specified to mount under
>        some circumstances).

I don't promise a dummy value for any "extended" field other than zero.

>        Apart from stx_mask (which is described above), the  fields  in
>        the statx structure are:
> 
>        stx_mode
>               The file type and mode.  See inode(7) for details.
>	 ...

Should this list either be in alphabetical order or offset-in-struct order?

This needs to be added:

	stx_attributes_mask
	      A mask indicating which bits in stx_attributes are supported by
	      the VFS and the filesystem.

>    File attributes
>        The stx_attributes field contains a  set  of  ORed  flags  that
>        indicate additional attributes of the file:

Probably should mention stx_attributes_mask here also.  Perhaps:

       The stx_attributes field contains a set of ORed flags that
       indicate additional attributes of the file.  Note that any
       attribute that is not indicated as supported by
       stx_attributes_mask has no usable value here.  The bits in
       stx_attributes_mask correspond bit-by-bit to stx_attributes.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
