From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Wed, 17 Oct 2012 16:30:04 -0700
Message-ID: <20121017163004.fb9de1b3.akpm@linux-foundation.org>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com>
	<CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: "Paton J. Lewis" <palewis@adobe.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>, Davide Libenzi <davidel@xmailserver.org>, libc-alpha@sourceware.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 16 Oct 2012 17:12:57 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> On Thu, Aug 23, 2012 at 11:15 PM, Paton J. Lewis <palewis@adobe.com> wrote:
> > From: "Paton J. Lewis" <palewis@adobe.com>
> >
> > Enhanced epoll_ctl to support EPOLL_CTL_DISABLE, which disables an epoll item.
> > If epoll_ctl doesn't return -EBUSY in this case, it is then safe to delete the
> > epoll item in a multi-threaded environment. Also added a new test_epoll self-
> > test app to both demonstrate the need for this feature and test it.
> 
> (There's a lot of background missing from this version of the patch
> that was included in the previous version
> [http://thread.gmane.org/gmane.linux.kernel/1311457]. It helps to
> include the full rationale with a revised patch--best not to assume
> that someone has the context of past mails when reading a revised
> patch.)
> 
> I've taken a look at this patch as it currently stands in 3.7-rc1, and
> done a bit of testing. (By the way, the test program
> tools/testing/selftests/epoll/test_epoll.c does not compile...)

Thanks for this.  You raise significant issues.  If we can't get these
fully resolved over the next month or so, we should revert the patch so
this new API doesn't get released in 3.7.  I have queued a patch to do
this and shall maintain it while I watch developments...
