From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: Re: [PATCH v5 5/7] proc: instantiate only pids that we can ptrace on
 'limit_pids=1' mount option
Date: Mon, 14 May 2018 10:34:39 +0200
Message-ID: <20180514083439.GB28179@comp-core-i7-2640m-0182e6>
References: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
 <7c638a92-8c40-fa15-8c63-777232588137@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c638a92-8c40-fa15-8c63-777232588137@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@ca>
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 09:09:04AM -0700, Randy Dunlap wrote:
> On 05/11/2018 02:36 AM, Alexey Gladkov wrote:
> > From: Djalal Harouni <tixxdz@gmail.com>
> > 
> > If "limit_pids=1" mount option is set then do not instantiate pids that
> > we can not ptrace. "limit_pids=1" means that procfs should only contain
> > pids that the caller can ptrace.
> 
> Where can I find documentation on these mount options (pidonly, limit_pids)?

The documentation is not ready yet. It will be added in the next version
of the patchset.

-- 
Rgrds, legion
