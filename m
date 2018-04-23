From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH net-next 0/4] mm,tcp: provide mmap_hook to solve lockdep
 issue
Date: Mon, 23 Apr 2018 14:14:33 -0700
Message-ID: <9ed6083f-d731-945c-dbcd-f977c5600b03@kernel.org>
References: <20180420155542.122183-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420155542.122183-1-edumazet@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Soheil Hassas Yeganeh <soheil@google.com>, Eric Dumazet <eric.dumazet@gmail.com>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 04/20/2018 08:55 AM, Eric Dumazet wrote:
> This patch series provide a new mmap_hook to fs willing to grab
> a mutex before mm->mmap_sem is taken, to ensure lockdep sanity.
> 
> This hook allows us to shorten tcp_mmap() execution time (while mmap_sem
> is held), and improve multi-threading scalability.
> 

I think that the right solution is to rework mmap() on TCP sockets a 
bit.  The current approach in net-next is very strange for a few reasons:

1. It uses mmap() as an operation that has side effects besides just 
creating a mapping.  If nothing else, it's surprising, since mmap() 
doesn't usually do that.  But it's also causing problems like what 
you're seeing.

2. The performance is worse than it needs to be.  mmap() is slow, and I 
doubt you'll find many mm developers who consider this particular abuse 
of mmap() to be a valid thing to optimize for.

3. I'm not at all convinced the accounting is sane.  As far as I can 
tell, you're allowing unprivileged users to increment the count on 
network-owned pages, limited only by available virtual memory, without 
obviously charging it to the socket buffer limits.  It looks like a 
program that simply forgot to call munmap() would cause the system to 
run out of memory, and I see no reason to expect the OOM killer to have 
any real chance of killing the right task.

4. Error handling sucks.  If I try to mmap() a large range (which is the 
whole point -- using a small range will kill performance) and not quite 
all of it can be mapped, then I waste a bunch of time in the kernel and 
get *none* of the range mapped.

I would suggest that you rework the interface a bit.  First a user would 
call mmap() on a TCP socket, which would create an empty VMA.  (It would 
set vm_ops to point to tcp_vm_ops or similar so that the TCP code could 
recognize it, but it would have no effect whatsoever on the TCP state 
machine.  Reading the VMA would get SIGBUS.)  Then a user would call a 
new ioctl() or setsockopt() function and pass something like:

struct tcp_zerocopy_receive {
   void *address;
   size_t length;
};

The kernel would verify that [address, address+length) is entirely 
inside a single TCP VMA and then would do the vm_insert_range magic.  On 
success, length is changed to the length that actually got mapped.  The 
kernel could do this while holding mmap_sem for *read*, and it could get 
the lock ordering right.  If and when mm range locks ever get merged, it 
could switch to using a range lock.

Then you could use MADV_DONTNEED or another ioctl/setsockopt to zap the 
part of the mapping that you're done with.

Does this seem reasonable?  It should involve very little code change, 
it will run faster, it will scale better, and it is much less weird IMO.
