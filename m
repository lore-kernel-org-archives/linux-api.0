From: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Subject: Re: [PATCH] x86: always use SYSCALL_DEFINE*
Date: Wed, 14 Mar 2018 09:43:46 +0000
Message-ID: <C59EE7A8-35FC-47D6-AB63-33690684310E@amazon.com>
References: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
 <CAG48ez1RBhBbH8jHwseeZMQwdKciLdjYhoy3O9yDs8WEpMk2TQ@mail.gmail.com>
 <CALCETrXh7BLrv4AsQm-Vpwmd=ttnGWQXV6dAxxi3GVevxnMO7w@mail.gmail.com>
 <20180314054802.GC8354@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180314054802.GC8354@light.dominikbrodowski.net>
Content-Language: en-US
Content-ID: <7F3233CC6032AC469BA6E237B069A039@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Andy Lutomirski <luto@amacapital.net>, "Tautschnig, Michael" <tautschn@amazon.co.uk>, Jann Horn <jannh@google.com>, "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi Dominik,

> On 14 Mar 2018, at 05:48, Dominik Brodowski <linux@dominikbrodowski.net> =
wrote:
> [...]
> ... the ioperm change is already in mainline (did an equivalent change a
> couple of days ago), but the sigreturn/rt_sigreturn changes still seem
> useful. Could you send a fresh patch with just these two changes; and -- =
if
> the x86 maintainers agree -- I will push it with my syscall-related chang=
es?

Thanks for all this cleanup work. I have posted the {rt_,}sigreturn changes=
 as
"[PATCH] x86/sigreturn: use SYSCALL_DEFINE0".

Best,
Michael






Amazon Web Services UK Limited. Registered in England and Wales with regist=
ration number 08650665 with its registered office at 1 Principal Place, Wor=
ship Street, London, EC2A 2FA, United Kingdom.
