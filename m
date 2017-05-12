From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 09:43:40 +0200
Message-ID: <CAK8P3a2ynRObJLn2Hh2r9_2k5+O08jErPC_UnnDmemd1jXsnkw@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170512070012.7dysuhbkcas7ibaj@gmail.com> <20170512071549.GP390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512071549.GP390-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 9:15 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Fri, May 12, 2017 at 09:00:12AM +0200, Ingo Molnar wrote:
>
>> > How about trying to remove all of them?  If we could actually get rid
>> > of all of them, we could drop the arch support, and we'd get faster,
>> > simpler, shorter uaccess code throughout the kernel.
>>
>> I'm all for that!
>
> Oh, for...  Ingo, do you really want to go through all ->write() and ->read()
> instances, converting all of them to iov_iter?  Or, better yet, deal with
> the patch flood from Nick Krause sock puppet brigade?

How realistic and how useful would it be to first completely eliminate
the ones that are in loadable modules and then wrapping the definition
in #ifndef MODULE (or even make it an extern function)?

This should be a fairly complete list of the modular users:

drivers/block/drbd/drbd_main.c: set_fs(KERNEL_DS);
drivers/input/serio/hp_sdc.c:   set_fs(KERNEL_DS);
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          set_fs(KERNEL_DS);
drivers/misc/lkdtm_bugs.c:      set_fs(KERNEL_DS);
drivers/s390/crypto/pkey_api.c: set_fs(KERNEL_DS);
drivers/staging/comedi/drivers/serial2002.c:    set_fs(KERNEL_DS);
drivers/staging/lustre/lnet/libcfs/tracefile.c: set_fs(get_ds());
drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:
 set_fs(KERNEL_DS);
drivers/staging/rtl8723bs/os_dep/osdep_service.c:               oldfs
= get_fs(); set_fs(get_ds());
drivers/usb/gadget/function/f_mass_storage.c:   set_fs(get_ds());
drivers/usb/gadget/function/u_uac1.c:   set_fs(KERNEL_DS);
drivers/vhost/vhost.c:  set_fs(USER_DS);
drivers/video/fbdev/core/fbmem.c:       set_fs(KERNEL_DS);
drivers/video/fbdev/hpfb.c:     set_fs(KERNEL_DS);
fs/autofs4/waitq.c:     set_fs(KERNEL_DS);
fs/binfmt_aout.c:       set_fs(KERNEL_DS);
fs/binfmt_elf.c:                set_fs(USER_DS);
fs/binfmt_elf_fdpic.c:  set_fs(KERNEL_DS);
fs/btrfs/send.c:        set_fs(KERNEL_DS);
fs/ext4/ioctl.c:                set_fs(KERNEL_DS);
fs/nfsd/vfs.c:  set_fs(KERNEL_DS);
net/9p/trans_fd.c:      set_fs(get_ds());
net/ipv6/addrconf.c:                    set_fs(KERNEL_DS);
net/ipv6/exthdrs.c:     set_fs(KERNEL_DS);
net/sunrpc/svcsock.c:   oldfs = get_fs(); set_fs(KERNEL_DS);
sound/core/oss/pcm_oss.c:       set_fs(get_ds());
sound/core/pcm_native.c:        set_fs(get_ds());
sound/drivers/opl3/opl3_oss.c:  set_fs(get_ds());
sound/oss/dmabuf.c:     set_fs(get_ds());
sound/oss/swarm_cs4297a.c:                set_fs(KERNEL_DS);
sound/pci/emu10k1/emufx.c:      set_fs(get_ds());
sound/pci/hda/hda_codec.c:              set_fs(get_ds());

     Arnd
