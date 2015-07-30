From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH V6 6/6] mips: Add entry for new mlock2 syscall
Date: Thu, 30 Jul 2015 16:32:52 +0200
Message-ID: <20150730143252.GF25552@linux-mips.org>
References: <1438184575-10537-1-git-send-email-emunson@akamai.com>
 <1438184575-10537-7-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438184575-10537-7-git-send-email-emunson@akamai.com>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 11:42:55AM -0400, Eric B Munson wrote:

> A previous commit introduced the new mlock2 syscall, add entries for the
> MIPS architecture.

Looking good, so

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Recently somebody else was floating around a patch that was adding
three syscalls.  Not sure if in the end the adding the syscall part to
non-x86 was dropped.  Just mentioning in case there are any conflicts;
in particulary nobody should rely on syscall numbers unless they're
for something in Linus' tree!

  Ralf
