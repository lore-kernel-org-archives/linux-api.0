From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v7 2/2] selftests: add tests for pidfd_send_signal()
Date: Tue, 8 Jan 2019 11:54:15 -0600
Message-ID: <20190108175415.GA22353@mail.hallyn.com>
References: <20190102161654.9093-1-christian@brauner.io>
 <20190102161654.9093-2-christian@brauner.io>
 <20190108175306.GF29009@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108175306.GF29009@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Tue, Jan 08, 2019 at 10:53:06AM -0700, Tycho Andersen wrote:
> On Wed, Jan 02, 2019 at 05:16:54PM +0100, Christian Brauner wrote:
> > +			/*
> > +			 * Stop the child so we can inspect whether we have
> > +			 * recycled pid PID_RECYCLE.
> > +			 */
> > +			close(pipe_fds[0]);
> > +			ret = kill(recycled_pid, SIGSTOP);
> > +			close(pipe_fds[1]);
> > +			if (ret) {
> > +				(void)wait_for_pid(recycled_pid);
> > +				_exit(PIDFD_ERROR);
> > +			}
> 
> Sorry for being late to the party, but I wonder if this whole thing
> couldn't be simplified with /proc/sys/kenrel/ns_last_pid?

no, bc it's not namespaced :)
