From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] userfaultfd: non-cooperative: syncronous events
Date: Fri, 2 Mar 2018 15:38:49 -0800
Message-ID: <20180302153849.d9d7b9a873755c6f5e883d0d@linux-foundation.org>
References: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, crml <criu@openvz.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Feb 2018 10:19:49 +0200 Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:

> Hi,
> 
> These patches add ability to generate userfaultfd events so that their
> processing will be synchronized with the non-cooperative thread that caused
> the event.
> 
> In the non-cooperative case userfaultfd resumes execution of the thread
> that caused an event when the notification is read() by the uffd monitor.
> In some cases, like, for example, madvise(MADV_REMOVE), it might be
> desirable to keep the thread that caused the event suspended until the
> uffd monitor had the event handled to avoid races between the thread that
> caused the and userfaultfd ioctls.
> 
> Theses patches extend the userfaultfd API with an implementation of
> UFFD_EVENT_REMOVE_SYNC that allows to keep the thread that triggered
> UFFD_EVENT_REMOVE until the uffd monitor would not wake it explicitly.

"might be desirable" is a bit weak.  It might not be desirable, too ;)

_Is_ it desirable?  What are the use-cases and what is the end-user
benefit?
