From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 09:11:54 +0100
Message-ID: <20170512081154.GQ390@ZenIV.linux.org.uk>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170512070012.7dysuhbkcas7ibaj@gmail.com>
 <20170512071549.GP390@ZenIV.linux.org.uk>
 <CAK8P3a2ynRObJLn2Hh2r9_2k5+O08jErPC_UnnDmemd1jXsnkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2ynRObJLn2Hh2r9_2k5+O08jErPC_UnnDmemd1jXsnkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 09:43:40AM +0200, Arnd Bergmann wrote:

> How realistic and how useful would it be to first completely eliminate
> the ones that are in loadable modules and then wrapping the definition
> in #ifndef MODULE (or even make it an extern function)?

Eliminate _what_?  ->read() and ->write() instances?

> This should be a fairly complete list of the modular users:
> 
> drivers/block/drbd/drbd_main.c: set_fs(KERNEL_DS);

Ah, set_fs()...  Sure, many of those can be killed off.  Wouldn't be
a bad idea, but I don't understand what difference does modular/built-in
make here...

This one: AFAICS doesn't give a damn about set_fs() at all.

> drivers/input/serio/hp_sdc.c:   set_fs(KERNEL_DS);

Open-coded probe_kernel_read(), apparently.

> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:          set_fs(KERNEL_DS);

massive compat ioctl crap.

> drivers/misc/lkdtm_bugs.c:      set_fs(KERNEL_DS);

insane.

> drivers/s390/crypto/pkey_api.c: set_fs(KERNEL_DS);

No idea.

> drivers/staging/comedi/drivers/serial2002.c:    set_fs(KERNEL_DS);

Open-coded kernel_write(); to some character device, no less...  And similar
for kernel_read(), apparently.

> drivers/staging/lustre/lnet/libcfs/tracefile.c: set_fs(get_ds());

Fuck knows; kernel_write() might do it.  Depends upon what it's writing
to.

You've missed other places in lustre, BTW - including the ioctls on
sockets, etc.

> drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:
>  set_fs(KERNEL_DS);

Compat ioctl crap, again.

> drivers/staging/rtl8723bs/os_dep/osdep_service.c:               oldfs
> = get_fs(); set_fs(get_ds());

Oh, lovely - reading an arbitrary (as in, specified by pathname) file.
Firmware (mis)handling?

> drivers/usb/gadget/function/f_mass_storage.c:   set_fs(get_ds());

No idea.

> drivers/usb/gadget/function/u_uac1.c:   set_fs(KERNEL_DS);

kernel_write(), by the look of it.  Or something similar.

> drivers/vhost/vhost.c:  set_fs(USER_DS);

kernel thread doing use_mm()

> drivers/video/fbdev/core/fbmem.c:       set_fs(KERNEL_DS);

compat ioctl.

> drivers/video/fbdev/hpfb.c:     set_fs(KERNEL_DS);

probe_kernel_read()

> fs/autofs4/waitq.c:     set_fs(KERNEL_DS);

kernel_write()

> fs/binfmt_aout.c:       set_fs(KERNEL_DS);
> fs/binfmt_elf.c:                set_fs(USER_DS);
> fs/binfmt_elf_fdpic.c:  set_fs(KERNEL_DS);

coredump stuff.

> fs/btrfs/send.c:        set_fs(KERNEL_DS);
kernel_write()

Anyway, what's special about modules?  IDGI...
