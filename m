From: chrubis@suse.cz
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 17:42:46 +0200
Message-ID: <20140515154246.GC6926@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
 <5374C54B.7040408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5374C54B.7040408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi!
> People have a number of times noted that there are problems
> with syscall(), but I'm not knowledgeable on the details.
> I'd happily take a patch to the man page (which, for historical
> reasons, is actually syscall(2)) that explains the the problems 
> (and ideally notes those platforms where there are no problems).

Have a look at this commit that tries to deal with passing 64 bit
numbers to syscalls. On 32 bit ABI (but not on X32) these needs to be
split up (accordingly to machine endianity).

https://github.com/linux-test-project/ltp/commit/04afb02b4280a20c262054e8f99a3fad4ad54916

-- 
Cyril Hrubis
chrubis@suse.cz
