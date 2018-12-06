From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v2 0/1] Add prctl to kill descendants on exit
Date: Thu, 06 Dec 2018 16:54:03 +0100
Message-ID: <9264c60225f95cb1ca4d3d529972520be08a95b0.camel@bitron.ch>
References: <20181127225408.7553-2-j@bitron.ch>
         <20181130080004.23635-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130080004.23635-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2018-11-30 at 08:00 +0000, Jürg Billeter wrote:
> This patch adds a new prctl to kill all descendant processes on exit.
> See commit message for details of the prctl.
> 
> This is a replacement of PR_SET_PDEATHSIG_PROC I proposed last year [1].
> In the following discussion, Oleg suggested this approach.
> 
> The motivation for this is to provide a lightweight mechanism to prevent
> stray processes. There is also a related Bugzilla entry [2].

Andrew, Eric, does this look good to you as well?

Jürg
