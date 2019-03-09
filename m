From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] mincore() and IOCB_NOWAIT adjustments
Date: Sat, 9 Mar 2019 08:53:52 -0800
Message-ID: <CAHk-=wgFY+yu=mQU=WqAC-_2aU+A6dFcY3D-Um-Q3hXobB8JfA@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <nycvar.YFH.7.76.1903061310170.19912@cbobk.fhfr.pm>
 <20190306143547.c686225447822beaf3b6e139@linux-foundation.org>
 <nycvar.YFH.7.76.1903062342020.19912@cbobk.fhfr.pm> <20190306152337.e06cbc530fbfbcfcfe0dc37c@linux-foundation.org>
 <20190306233209.GA7753@nautica> <20190306153819.3510a19ffe510b674a7890ce@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306153819.3510a19ffe510b674a7890ce@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Jiri Kosina <jikos@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@amacapital.net>, Cyril Hrubis <chrubis@suse.cz>, Daniel Gruss <daniel@gruss.cc>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 6, 2019 at 3:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus, do you have thoughts on
> http://lkml.kernel.org/r/20190130124420.1834-4-vbabka@suse.cz ?

I think that's fine, and probably the right thing to do, but I also
suspect that nobody actually cares ;(

                 Linus
