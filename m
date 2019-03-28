From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Subject: Re: [RESEND PATCH v1] moduleparam: Save information about built-in
 modules in separate file
Date: Thu, 28 Mar 2019 10:56:57 -0700
Message-ID: <CAKi4VAKA-kRv2MyfiL4zRV-zaz9kUDZ+QrBpbqSgAZhzOKgSKQ@mail.gmail.com>
References: <20190315101013.GN8455@Legion-PC.fortress> <CAK7LNATsm23e_CuyfFw7_CR8xZQ3HnwNHCXhEm_zQZU2PUGK5A@mail.gmail.com>
 <20190326172411.GA15936@Legion-PC.fortress> <20190327154025.GB23293@linux-8ccs>
 <20190327160440.GE15936@Legion-PC.fortress>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327160440.GE15936@Legion-PC.fortress>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Jessica Yu <jeyu@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-api@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 9:04 AM Alexey Gladkov <gladkov.alexey@gmail.com> w=
rote:
>
> On Wed, Mar 27, 2019 at 04:40:25PM +0100, Jessica Yu wrote:
> > +++ Alexey Gladkov [26/03/19 18:24 +0100]:
> > >On Fri, Mar 22, 2019 at 02:34:12PM +0900, Masahiro Yamada wrote:
> > >> Hi.
> > >>
> > >> (added some people to CC)
> >
> > (Thanks Masahiro for the CC!)
> >
> > >>
> > >> On Fri, Mar 15, 2019 at 7:10 PM Alexey Gladkov <gladkov.alexey@gmail=
.com> wrote:
> > >> >
> > >> > Problem:
> > >> >
> > >> > When a kernel module is compiled as a separate module, some import=
ant
> > >> > information about the kernel module is available via .modinfo sect=
ion of
> > >> > the module.  In contrast, when the kernel module is compiled into =
the
> > >> > kernel, that information is not available.
> > >>
> > >>
> > >> I might be missing something, but
> > >> vmlinux provides info of builtin modules
> > >> in /sys/module/.
> > >
> > >No. There are definitely not all modules. I have a builtin sha256_gene=
ric,
> > >but I can't find him in the /sys/module.
> >
> > Yeah, you'll only find builtin modules under /sys/module/ if it has any=
 module
> > parameters, otherwise you won't find it there. As Masahiro already ment=
ioned,
> > if a builtin module has any parameters, they would be accessible under =
/sys/module/.
> >
> > >> (Looks like currently only module_param and MODULE_VERSION)
> > >>
> > >> This patch is not exactly the same, but I see a kind of overwrap.
> > >> I'd like to be sure if we want this new scheme.
> > >
> > >The /sys/module is only for running kernel. One of my use cases is
> > >to create an initrd for a new kernel.
> > >
> > >>
> > >> > Information about built-in modules is necessary in the following c=
ases:
> > >> >
> > >> > 1. When it is necessary to find out what additional parameters can=
 be
> > >> > passed to the kernel at boot time.
> > >>
> > >>
> > >> Actually, /sys/module/<module>/parameters/
> > >> exposes this information.
> > >>
> > >> Doesn't it work for your purpose?
> > >
> > >No, since creating an initrd needs to know all the modalias before
> > >I get the sysfs for new kernel. Also there are no modalias at all.
> > >
> > >> > 2. When you need to know which module names and their aliases are =
in
> > >> > the kernel. This is very useful for creating an initrd image.
> > >> >
> >
> > Hm, I do see one possible additional use-case for preserving module ali=
as
> > information for built-in modules - modprobe will currently error (I thi=
nk,
> > correct me if I'm wrong) if we try invoking modprobe with an alias of a
> > built-in module, simply because this information is not in modules.buil=
tin or
> > modules.alias.
>
> Yes. Patch for modprobe in my todo list. The reason I didn=E2=80=99t do i=
t was
> because I wasn=E2=80=99t sure that the file format was final.
>
> > Since kbuild already outputs modules.builtin, I would suggest outputtin=
g
> > something like a modules.builtin.alias file (and I guess maybe a module=
s.builtin.param
> > file too if that's deemed useful), in a format that is consumable by km=
od/modprobe,
> > so that modprobing an alias of a built-in module doesn't produce an err=
or. I
> > think this should be easy to do if we keep and parse the resulting .mod=
info for
> > builtin modules. This is just an idea, opinions welcome. I've added Luc=
as to CC
> > in case he has any thoughts.
>
> You don't like kernel.builtin.modinfo ?
>
> It is much easier to create and it has almost the same format as the
> modules. So I think it will be easier to parse in kmod.

adding a modules.builtin.alias with the same format of modules.alias
means during modprobe we would only need to load one more file to
lookup aliases. That doesn't mean the kernel built system should do it
though. The same way it's depmod job to create the
modules.alias{,.bin}, we could leave this to depmod if it's in fact
useful to split the information.

I think your version is simple enough and we would get more
information that would be useful for modinfo.
It would indeed be nice to output something useful in  "modinfo ext4".

In kmod, I think we would create modules.builtin.modinfo{,.bin} and
just add the aliases to modules.alias{,.bin},
This would keep the names consistent with what is already there.

thanks
Lucas De Marchi

>
> --
> Rgrds, legion
>
