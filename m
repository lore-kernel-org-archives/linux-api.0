From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Tue, 5 Sep 2017 15:53:20 -0700
Message-ID: <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org>
References: <20170905190500.GA13746@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905190500.GA13746@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tatsiana Brouka <Tatsiana_Brouka@epam.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Sep 2017 22:05:00 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Implement system call for bulk retrieveing of pids in binary form.
> 
> Using /proc is slower than necessary: 3 syscalls + another 3 for each thread +
> converting with atoi().
> 
> /proc may be not mounted especially in containers. Natural extension of
> hidepid=2 efforts is to not mount /proc at all.
> 
> It could be used by programs like ps, top or CRIU. Speed increase will
> become more drastic once combined with bulk retrieval of process statistics.

The patches are performance optimizations, but their changelogs contain
no performance measurements!

Demonstration of some compelling real-world performance benefits would
help things along a lot.
