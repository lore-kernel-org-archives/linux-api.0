From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Sun, 24 Sep 2017 14:31:23 -0700
Message-ID: <CALCETrWWUuzF7HaQAS2rf69KcqBrB9epvQPPgKEoK4MNbdVmEw@mail.gmail.com>
References: <20170924200620.GA24368@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170924200620.GA24368@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 24, 2017 at 1:06 PM, Alexey Dobriyan <adobriyan@gmail.com> wrot=
e:
> From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>
>
> Implement system call for bulk retrieveing of opened descriptors
> in binary form.
>
> Some daemons could use it to reliably close file descriptors
> before starting. Currently they close everything upto some number
> which formally is not reliable. Other natural users are lsof(1) and CRIU
> (although lsof does so much in /proc that the effect is thoroughly buried=
).
>
> /proc, the only way to learn anything about file descriptors may not be
> available. There is unavoidable overhead associated with instantiating
> 3 dentries and 3 inodes and converting integers to strings and back.
>
> Benchmark:
>
>         N=3D1<<22 times
>         4 opened descriptors (0, 1, 2, 3)
>         opendir+readdir+closedir /proc/self/fd vs fdmap
>
>         /proc 8.31 =C4=85 0.37%
>         fdmap 0.32 =C4=85 0.72%

This doesn't have the semantic problem that pidmap does, but I still
wonder why this can't be accomplished by adding a new file in /proc.
