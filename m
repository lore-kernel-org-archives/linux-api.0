From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 5 May 2015 20:53:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505052050100.4225@nanos>
References: <20150421174711.GA5127@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150421174711.GA5127@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 21 Apr 2015, Josh Triplett wrote:
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>

Can you please clarify that SOB chain? It does not make any sense.

Thanks,

	tglx
