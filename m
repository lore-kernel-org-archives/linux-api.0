From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Allow user to request memory to be locked on page
 fault
Date: Fri, 8 May 2015 12:42:03 -0700
Message-ID: <20150508124203.6679b1d35ad9555425003929@linux-foundation.org>
References: <1431113626-19153-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1431113626-19153-1-git-send-email-emunson@akamai.com>
Sender: sparclinux-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri,  8 May 2015 15:33:43 -0400 Eric B Munson <emunson@akamai.com> wrote:

> mlock() allows a user to control page out of program memory, but this
> comes at the cost of faulting in the entire mapping when it is
> allocated.  For large mappings where the entire area is not necessary
> this is not ideal.
> 
> This series introduces new flags for mmap() and mlockall() that allow a
> user to specify that the covered are should not be paged out, but only
> after the memory has been used the first time.

Please tell us much much more about the value of these changes: the use
cases, the behavioural improvements and performance results which the
patchset brings to those use cases, etc.

