From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH v1 3/5] Yama: Enforces noexec mounts or file
 executability through O_MAYEXEC
Date: Tue, 8 Jan 2019 15:30:49 -0800
Message-ID: <CAGXu5jKHPE6WfbXpiwzm=vRbgJ-rCePxsrYmVzZ1+RURp-6nJg@mail.gmail.com>
References: <20181212081712.32347-1-mic@digikod.net> <20181212081712.32347-4-mic@digikod.net>
 <CAG48ez3SAW8EyaJ9T1U3qPoRhYwe4CCyL9bAxuc3GxjrXipi-A@mail.gmail.com>
 <f13bf750-f418-343c-baa6-9eee6e0f5e19@ssi.gouv.fr> <CAG48ez00CpXOOJPLgpQd_e0gG2KgYb1p8bwssA8FDOugHTxRAA@mail.gmail.com>
 <0f7d39f8-035b-8566-94c9-ea836b280e24@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0f7d39f8-035b-8566-94c9-ea836b280e24@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>
Cc: Jann Horn <jannh@google.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, philippe.trebuchet@ssi.gouv.fr, Shuah Khan <shuah@kernel.org>, thibaut.sautereau@ssi.gouv.fr, vincent.strubel@ssi.gouv.fr, Perez Yves-Alexis <yves-alexis.perez@ssi.gouv.fr>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 8, 2019 at 5:29 AM Micka=C3=ABl Sala=C3=BCn
<mickael.salaun@ssi.gouv.fr> wrote:
>
>
> On 03/01/2019 12:17, Jann Horn wrote:
> > On Thu, Dec 13, 2018 at 3:49 PM Micka=C3=ABl Sala=C3=BCn
> > <mickael.salaun@ssi.gouv.fr> wrote:
> >> On 12/12/2018 18:09, Jann Horn wrote:
> >>> On Wed, Dec 12, 2018 at 9:18 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod=
.net> wrote:
> >>>> Enable to either propagate the mount options from the underlying VFS
> >>>> mount to prevent execution, or to propagate the file execute permiss=
ion.
> >>>> This may allow a script interpreter to check execution permissions
> >>>> before reading commands from a file.
> >>>>
> >>>> The main goal is to be able to protect the kernel by restricting
> >>>> arbitrary syscalls that an attacker could perform with a crafted bin=
ary
> >>>> or certain script languages.  It also improves multilevel isolation
> >>>> by reducing the ability of an attacker to use side channels with
> >>>> specific code.  These restrictions can natively be enforced for ELF
> >>>> binaries (with the noexec mount option) but require this kernel
> >>>> extension to properly handle scripts (e.g., Python, Perl).

I like this idea, but I think it shouldn't live in Yama (since it is
currently intended to be a ptrace-policy-only LSM). It was
_originally_ designed to do various DAC improvements, but the
agreement was that those should live directly in the VFS instead (i.e.
the symlink, hardlink and now fifo and regular file defenses).

This should likely go in similarly. (But if not, it could also be its own L=
SM.)

--=20
Kees Cook
