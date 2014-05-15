From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 09:56:19 -0700
Message-ID: <5374F1B3.9080006@zytor.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com> <20140515154246.GC6926@rei.Home> <5374E2A4.2070408@zytor.com> <20140515160152.GA7529@rei.Home> <5374E653.2080309@zytor.com> <20140515161753.GA7959@rei.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140515161753.GA7959@rei.Home>
Sender: linux-kernel-owner@vger.kernel.org
To: chrubis@suse.cz
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 09:17 AM, chrubis@suse.cz wrote:
>>
>> It should be quite easy to extract from klibc.
> 
> That is not the main concern here. If I extract the code I would have to
> watch for any changes manually. If it was in a library or a separate
> repository all that would be needed is to add it as dependency/git
> submodule and I would get all updates automatically.
> 

Yes, and for that to happen someone needs to do the work to extract it.
 I don't have the cycles myself at the moment.

	-hpa
