From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/34] x86: Memory Protection Keys (v5)
Date: Fri, 4 Dec 2015 15:31:34 -0800
Message-ID: <CALCETrXwVb99hAvqR2o54aPwtpr8oubROtiRt45SiYRfUTAxCw@mail.gmail.com>
References: <20151204011424.8A36E365@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20151204011424.8A36E365@viggo.jf.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 3, 2015 at 5:14 PM, Dave Hansen <dave@sr71.net> wrote:
> Memory Protection Keys for User pages is a CPU feature which will
> first appear on Skylake Servers, but will also be supported on
> future non-server parts.  It provides a mechanism for enforcing
> page-based protections, but without requiring modification of the
> page tables when an application changes protection domains.  See
> the Documentation/ patch for more details.

What, if anything, happened to the signal handling parts?

Also, do you have a git tree for this somewhere?  I can't actually
enable it (my laptop, while very shiny, is not a Skylake server), but
I can poke around a bit.

--Andy
