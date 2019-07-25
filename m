From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 18:13:17 +0200
Message-ID: <20190725161316.GI4707@redhat.com>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <20190725103543.GF4707@redhat.com>
 <20190725104006.7myahvjtnbcgu3in@brauner.io>
 <20190725112503.GG4707@redhat.com>
 <20190725114359.GH4707@redhat.com>
 <20190725122650.4i3arct5rpchqmyt@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725122650.4i3arct5rpchqmyt@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/25, Christian Brauner wrote:
>
> The key is that you want to be able to create child processes in a
> shared library without the main programing having to know about this so
> that it can use P_ALL and never get stuff from the library.

OK, thanks...

in this case you should probablu pass 0 in CSIGNAL to ensure that the main
program won't be notified when that child exits.

Oleg.
