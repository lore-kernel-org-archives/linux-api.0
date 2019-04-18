From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/5] signal: use fdget() since we don't allow O_PATH
Date: Thu, 18 Apr 2019 15:17:23 +0200
Message-ID: <20190418131722.GC13701@redhat.com>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418101841.4476-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

On 04/18, Christian Brauner wrote:
>
> It's just semantically correct to use fdget()
> and return an error right from there instead of taking a reference and
> returning an error later.

agreed, and thanks for your explanations

Acked-by: Oleg Nesterov <oleg@redhat.com>
