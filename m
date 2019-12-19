From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 0/2] openat2: minor uapi cleanups
Date: Thu, 19 Dec 2019 12:19:50 +0100
Message-ID: <20191219111949.auriw6biphxxvdng@wittgenstein>
References: <20191219105533.12508-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <libc-alpha-return-108222-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191219105533.12508-1-cyphar@cyphar.com>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 19, 2019 at 09:55:28PM +1100, Aleksa Sarai wrote:
> While openat2(2) is still not yet in Linus's tree, we can take this
> opportunity to iron out some small warts that weren't noticed earlier:
> 
>   * A fix was suggested by Florian Weimer, to separate the openat2
>     definitions so glibc can use the header directly. I've put the
>     maintainership under VFS but let me know if you'd prefer it belong
>     ot the fcntl folks.
> 
>   * Having heterogenous field sizes in an extensible struct results in
>     "padding hole" problems when adding new fields (in addition the
>     correct error to use for non-zero padding isn't entirely clear ).
>     The simplest solution is to just copy clone(3)'s model -- always use
>     u64s. It will waste a little more space in the struct, but it
>     removes a possible future headache.

Am I imagining things or did I get the same patch series twice?

Christian
