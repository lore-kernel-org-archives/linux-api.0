From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Fri, 27 Dec 2019 07:38:39 -0700
Message-ID: <20191227143839.GB15663@cisco>
References: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal>
 <20191226115245.usf7z5dkui7ndp4w@wittgenstein>
 <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
 <57C06925-0CC6-4251-AD57-8FF1BC28F049@ubuntu.com>
 <20191227022446.37e64ag4uaqms2w4@yavin.dot.cyphar.com>
 <20191227023131.klnobtlfgeqcmvbb@yavin.dot.cyphar.com>
 <20191227114725.xsacnaoaaxdv6yg3@wittgenstein>
 <CAMp4zn8iMsRvDoDtrotfnEm2_UUULH9VRiR6q9u8CS4qham2Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn8iMsRvDoDtrotfnEm2_UUULH9VRiR6q9u8CS4qham2Eg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Aleksa Sarai <cyphar@cyphar.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 27, 2019 at 09:22:20AM -0500, Sargun Dhillon wrote:
> Just doing a simple copy_from_user, and for now, calling memchr_inv
> on the whole thing. We can drop the memset, and just leave a note to
> indicate that if unpadded fields are introduced in the future, this structure
> must be manually zeroed out. Although, this might be laying a trap for
> ourselves.

Yes, please keep the memset().

Tycho
