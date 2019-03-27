From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V31 19/25] x86/mmiotrace: Lock down the testmmiotrace module
Date: Wed, 27 Mar 2019 09:55:20 -0700
Message-ID: <CACdnJuv82qUnVhtZXHaHAJH0x9edS=j5X8awhhJmFfGAz5Ayzg@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-20-matthewgarrett@google.com> <20190327115749.5770a102@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327115749.5770a102@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 8:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 26 Mar 2019 11:27:35 -0700
> Matthew Garrett <matthewgarrett@google.com> wrote:
>
> > From: David Howells <dhowells@redhat.com>
> >
> > The testmmiotrace module shouldn't be permitted when the kernel is locked
> > down as it can be used to arbitrarily read and write MMIO space. This is
> > a runtime check rather than buildtime in order to allow configurations
> > where the same kernel may be run in both locked down or permissive modes
> > depending on local policy.
> >
>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> I'm curious. Should there be a mode to lockdown the tracefs directory
> too? As that can expose addresses.

That sounds like a reasonable thing to do in the confidentiality mode,
I don't think it'd be necessary in the integrity mode.
