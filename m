From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RESEND PATCH v1] moduleparam: Save information about built-in
 modules in separate file
Date: Thu, 28 Mar 2019 14:33:56 -0700
Message-ID: <CAKdAkRTxvJjuocVgENDPsmTjV+uNbD81wgReLRyF4CUFqzTF0Q@mail.gmail.com>
References: <20190315101013.GN8455@Legion-PC.fortress> <CAK7LNATsm23e_CuyfFw7_CR8xZQ3HnwNHCXhEm_zQZU2PUGK5A@mail.gmail.com>
 <20190326172411.GA15936@Legion-PC.fortress> <20190327154025.GB23293@linux-8ccs>
 <CAKi4VA+14kihzGFbMT623BwMbZEzgYU6+jz8MpR9jqoC059oog@mail.gmail.com> <20190328184546.GB23800@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328184546.GB23800@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, Jessica Yu <jeyu@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-modules <linux-modules@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 28, 2019 at 11:45 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 28, 2019 at 10:41:59AM -0700, Lucas De Marchi wrote:
> > On Wed, Mar 27, 2019 at 8:40 AM Jessica Yu <jeyu@kernel.org> wrote:
> > > >No. There are definitely not all modules. I have a builtin sha256_generic,
> > > >but I can't find him in the /sys/module.
> > >
> > > Yeah, you'll only find builtin modules under /sys/module/ if it has any module
> > > parameters, otherwise you won't find it there. As Masahiro already mentioned,
> > > if a builtin module has any parameters, they would be accessible under /sys/module/.
> >
> > Could we please change that and add the sysfs entry regardless of
> > what's being discussed here? Not having the entry there simply because
> > we don't have parameters for that module always annoyed me.

What is the benefit compared to wasting some memory for the directory?

>
> What is the sysfs directory going to show?  Will it just be empty?
>
> Feel free to send a patch for this, but from what I remember, it wasn't
> the easiest thing to do for some reason.  But given that the code was
> implemented before git was, I can't quite remember.

I am pretty sure we allow empty attribute groups, so it is probbaly as
simple as removing "If (!params) return 0;" form
module_param_sysfs_setup() and making sure we always create
"parameters" group instead of doing it on first visible parameter in
add_sysfs_param(). I suppose we no longer want to skip over parameters
that are not readable nor writable either?

Thanks.

-- 
Dmitry
