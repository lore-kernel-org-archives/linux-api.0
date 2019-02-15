From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/2] signal: add pidfd_send_signal() syscall
Date: Thu, 14 Feb 2019 22:00:49 -0700
Message-ID: <20190215050049.GC19258@cisco>
References: <20190102161654.9093-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190102161654.9093-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Wed, Jan 02, 2019 at 05:16:53PM +0100, Christian Brauner wrote:
> The kill() syscall operates on process identifiers (pid). After a process
> ...

Fashionably late to the party, but feel free to consider these two:

Reviewed-by: Tycho Andersen <tycho@tycho.ws>
