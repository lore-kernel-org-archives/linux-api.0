From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 00/19] converting system calls to 64-bit time_t, part 1
Date: Thu, 07 May 2015 09:39:18 +0200
Message-ID: <1430984358.8171.28.camel@x220>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
	 <1430983678.8171.23.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-58742-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1430983678.8171.23.camel@x220>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-05-07 at 09:27 +0200, Paul Bolle wrote:
> On Wed, 2015-05-06 at 18:30 +0200, Arnd Bergmann wrote:
> > * After all system calls are converted, we can change one architecture
> >   at a time to select ARCH_HAS_COMPAT_TIME, and modify its system
> >   call table accordingly. In this version, I do it for ARM32, x86-32,
> >   and x86-64 for demonstration purposes.
> 
> Perhaps this was correct for your first draft. Because this series adds
> ARCH_HAS_COMPAT_TIME in 04/19, but it doesn't add any selects of that
> symbol, does it? As far as I can see ARCH_HAS_COMPAT_TIME simply
> functions as an alias for COMPAT in this series.
> 
> > * A follow-up series changes over all other architectures.
> > 
> > * The last patch in the series changes the CONFIG_COMPAT_TIME
> >   Kconfig symbol to be user visible. Disabling this symbol will
> >   get you a kernel that intentionally breaks support for old tasks
> >   in order to provide an interface that will survive 2038.
> 
> This doesn't happen in 19/19, or in any other patch in this series.
> Maybe also something that has changed since the first draft.
> 
> >   This is meant mostly as a debugging help for now, to let people
> >   build a y2038 safe distro, but at some point in the 2030s, we
> >   should remove that option and all the compat handling.

And then it occurred to me to check the y2038-syscalls git branch you
referenced. After which the above made much more sense. (Though my
remark that ARCH_HAS_COMPAT_TIME simply functions as an alias for COMPAT
also seems to hold for that branch.)


Paul Bolle
