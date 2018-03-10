From: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Subject: Re: [PATCH] x86: always use SYSCALL_DEFINE*
Date: Sat, 10 Mar 2018 20:59:46 +0000
Message-ID: <6490B647-209A-4CE6-BFDC-5EC2F62B466D@amazon.com>
References: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Content-Language: en-US
Content-ID: <7E3E0FFC7CEC3645BBC232E601217066@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 10 Mar 2018, at 20:55, Tautschnig, Michael <tautschn@amazon.co.uk> wrote:
> =

> All syscall arguments are passed in as types of the same byte size as
> unsigned long (width of full registers). Using a smaller type without a
> cast may result in losing bits of information. SYSCALL_DEFINE* introduce
> adequate type casts. All definitions of syscalls in x86 except for those
> patched here have already been using the appropriate SYSCALL_DEFINE*.
[...]

Additional context: I had previously made an attempt to ensure type
consistency of sys_ioperm as "Syscall arguments are unsigned long (full
registers)" (https://lkml.org/lkml/2016/7/4/336). I hope the new proposal
is more acceptable.

Best,
Michael



Amazon Web Services UK Limited. Registered in England and Wales with regist=
ration number 08650665 with its registered office at 1 Principal Place, Wor=
ship Street, London, EC2A 2FA, United Kingdom.
