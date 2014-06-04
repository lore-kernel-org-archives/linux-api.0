From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in kernel loading
Date: Wed, 4 Jun 2014 21:39:10 +0200
Message-ID: <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com> <20140604092214.GA17528@dhcp-17-89.nay.redhat.com>
 <20140604175031.GA4406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140604175031.GA4406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Vivek,

As per Documentation/SubmitChecklist , please CC linux-api@ on patces
that change the ABI/API. See
https://www.kernel.org/doc/man-pages/linux-api-ml.html.

Also, is there some draft man page for this new system call?

Thanks,

Michael

On Wed, Jun 4, 2014 at 7:50 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jun 04, 2014 at 05:22:14PM +0800, WANG Chao wrote:
>
> [..]
>> > Index: kexec-tools/kexec/kexec.h
>> > ===================================================================
>> > --- kexec-tools.orig/kexec/kexec.h  2014-06-02 14:34:16.719774316 -0400
>> > +++ kexec-tools/kexec/kexec.h       2014-06-02 14:34:42.010036325 -0400
>> > @@ -156,6 +156,13 @@ struct kexec_info {
>> >     unsigned long kexec_flags;
>> >     unsigned long backup_src_start;
>> >     unsigned long backup_src_size;
>> > +   /* Set to 1 if we are using kexec2 syscall */
>> > +   unsigned long file_mode :1;
>> > +
>> > +   /* Filled by kernel image processing code */
>> > +   int initrd_fd;
>> > +   char *command_line;
>> > +   int command_line_len;
>> >  };
>> >
>> >  struct arch_map_entry {
>> > @@ -207,6 +214,7 @@ extern int file_types;
>> >  #define OPT_UNLOAD         'u'
>> >  #define OPT_TYPE           't'
>> >  #define OPT_PANIC          'p'
>> > +#define OPT_USE_KEXEC2_SYSCALL     's'
>> >  #define OPT_MEM_MIN             256
>> >  #define OPT_MEM_MAX             257
>> >  #define OPT_REUSE_INITRD   258
>> > @@ -230,6 +238,7 @@ extern int file_types;
>> >     { "mem-min",            1, 0, OPT_MEM_MIN }, \
>> >     { "mem-max",            1, 0, OPT_MEM_MAX }, \
>> >     { "reuseinitrd",        0, 0, OPT_REUSE_INITRD }, \
>> > +   { "use-kexec2-syscall", 0, 0, OPT_USE_KEXEC2_SYSCALL }, \
>> >     { "debug",              0, 0, OPT_DEBUG }, \
>> >
>> >  #define KEXEC_OPT_STR "h?vdfxluet:p"
>>
>> This line,
>> #define KEXEC_OPT_STR "h?vdfxluet:p"
>>
>> should be something like,
>> #define KEXEC_OPT_STR "h?vdfxluet:ps"
>
> Thanks chao. I will fix it.
>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
