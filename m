From: Josh Snyder <joshs@netflix.com>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Tue, 15 Jan 2019 16:42:08 -0800
Message-ID: <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com>
References: <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com> <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm> <20190109043906.GF27534@dastard> <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com> <20190110004424.GH27534@dastard> <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com> <20190110070355.GJ27534@dastard> <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com> <20190110122442.GA21216@nautica> <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote on Thu, Jan 10, 2019:
> So right now, I consider the mincore change to be a "try to probe the
> state of mincore users", and we haven't really gotten a lot of
> information back yet.

<raises hand>

For Netflix, losing accurate information from the mincore syscall would
lengthen database cluster maintenance operations from days to months.  We
rely on cross-process mincore to migrate the contents of a page cache from
machine to machine, and across reboots.

To do this, I wrote and maintain happycache [1], a page cache dumper/loader
tool. It is quite similar in architecture to pgfincore, except that it is
agnostic to workload. The gist of happycache's operation is "produce a dump
of residence status for each page, do some operation, then reload exactly
the same pages which were present before." happycache is entirely dependent
on accurate reporting of the in-core status of file-backed pages, as
accessed by another process.

We primarily use happycache with Cassandra, which (like Postgres +
pgfincore) relies heavily on OS page cache to reduce disk accesses. Because
our workloads never experience a cold page cache, we are able to provision
hardware for a peak utilization level that is far lower than the
hypothetical "every query is a cache miss" peak.

A database warmed by happycache can be ready for service in seconds
(bounded only by the performance of the drives and the I/O subsystem), with
no period of in-service degradation. By contrast, putting a database in
service without a page cache entails a potentially unbounded period of
degradation (at Netflix, the time to populate a single node's cache via
natural cache misses varies by workload from hours to weeks). If a single
node upgrade were to take weeks, then upgrading an entire cluster would
take months. Since we want to apply security upgrades (and other things) on
a somewhat tighter schedule, we would have to develop more complex
solutions to provide the same functionality already provided by mincore.

At the bottom line, happycache is designed to benignly exploit the same
information leak documented in the paper [2]. I think it makes perfect
sense to remove cross-process mincore functionality from unprivileged
users, but not to remove it entirely.

Josh Snyder
Netflix Cloud Database Engineering

[1] https://github.com/hashbrowncipher/happycache
[2] https://arxiv.org/abs/1901.01161
