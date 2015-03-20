From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to automatically reap the child process
Date: Fri, 20 Mar 2015 11:46:33 -0700
Message-ID: <1766646.jusoNDOCPE@tjmaciei-mobl4>
References: <cover.1426376419.git.josh@joshtriplett.org> <20150315233439.GA31890@thin> <20150320181404.GA26343@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150320181404.GA26343@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 20 March 2015 19:14:04 Oleg Nesterov wrote:
> Also. I forgot that the kernel always resets ->exit_signal to SIGCHLD on
> exec or reparenting. Reparenting is probably fine. But what about exec?
> Should it keep ->exit_signal == 0 if "autoreap" ? I think it should not, to
> avoid the strange special case.

Not delivering any signal was the objective of this patch series, so yes 
exit_signal == 0 should survive an exec and even re-exec.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
