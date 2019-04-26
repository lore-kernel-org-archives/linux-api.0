From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V3] mm: Allow userland to request that the kernel clear
 memory on release
Date: Fri, 26 Apr 2019 11:10:22 -0700
Message-ID: <CACdnJuuVBb8bOUGGq0H+Ask_ufT3X9YH42o5nAGQK0TCf+aKWg@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190425225828.212472-1-matthewgarrett@google.com> <d058d1ef-994f-ea6b-b6b4-bcd838a9fe2f@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d058d1ef-994f-ea6b-b6b4-bcd838a9fe2f@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 26, 2019 at 12:45 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 4/26/19 12:58 AM, Matthew Garrett wrote:
> > Updated based on feedback from Jann - for now let's just prevent setting
> > the flag on anything that has already mapped some pages, which avoids
> > child processes being able to interfere with the parent. In addition,
>
> That makes the API quite tricky and different from existing madvise()
> modes that don't care. One would for example have to call
> madvise(MADV_WIPEONRELEASE) before mlock(), otherwise mlock() would
> fault the pages in (unless MLOCK_ONFAULT). As such it really looks like
> a mmap() flag, but that's less flexible.
>
> How bout just doing the CoW on any such pre-existing pages as part of
> the madvise(MADV_WIPEONRELEASE) call?

I'll look into the easiest way to do that.
