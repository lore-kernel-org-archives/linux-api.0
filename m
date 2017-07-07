From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH 1/1] mm/mremap: add MREMAP_MIRROR flag for existing
 mirroring functionality
Date: Fri, 7 Jul 2017 10:29:52 -0700
Message-ID: <e328ff6a-2c4b-ec26-cc28-e24b7b35a463@oracle.com>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
 <1499357846-7481-2-git-send-email-mike.kravetz@oracle.com>
 <20170707102324.kfihkf72sjcrtn5b@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170707102324.kfihkf72sjcrtn5b@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 07/07/2017 03:23 AM, Kirill A. Shutemov wrote:
> On Thu, Jul 06, 2017 at 09:17:26AM -0700, Mike Kravetz wrote:
>> The mremap system call has the ability to 'mirror' parts of an existing
>> mapping.  To do so, it creates a new mapping that maps the same pages as
>> the original mapping, just at a different virtual address.  This
>> functionality has existed since at least the 2.6 kernel.
>>
>> This patch simply adds a new flag to mremap which will make this
>> functionality part of the API.  It maintains backward compatibility with
>> the existing way of requesting mirroring (old_size == 0).
>>
>> If this new MREMAP_MIRROR flag is specified, then new_size must equal
>> old_size.  In addition, the MREMAP_MAYMOVE flag must be specified.
> 
> The patch breaks important invariant that anon page can be mapped into a
> process only once.

Actually, the patch does not add any new functionality.  It only provides
a new interface to existing functionality.

Is it not possible to have an anon page mapped twice into the same process
via system V shared memory?  shmget(anon), shmat(), shmat.  
Of course, those are shared rather than private anon pages.

> 
> What is going to happen to mirrored after CoW for instance?
> 
> In my opinion, it shouldn't be allowed for anon/private mappings at least.
> And with this limitation, I don't see much sense in the new interface --
> just create mirror by mmap()ing the file again.

The code today works for anon shared mappings.  See simple program below.

You are correct in that it makes little or no sense for private mappings.
When looking closer at existing code, mremap() creates a new private
mapping in this case.  This is most likely a bug.

Again, my intention is not to create new functionality but rather document
existing functionality as part of a programming interface.

-- 
Mike Kravetz

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#define __USE_GNU
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <time.h>

#define H_PAGESIZE (2 * 1024 * 1024)

int hugetlb = 0;

#define PROTECTION (PROT_READ | PROT_WRITE)
#define ADDR (void *)(0x0UL)
/* #define FLAGS (MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB) */
#define FLAGS (MAP_SHARED|MAP_ANONYMOUS)

int main(int argc, char ** argv)
{
	int fd, ret;
	int i;
	long long hpages, tpage;
	void *addr;
	void *addr2;
	char foo;

	if (argc == 2) {
		if (!strcmp(argv[1], "hugetlb"))
			hugetlb = 1;
	}

	hpages = 5;

	printf("Reserving an address ...\n");
	addr = mmap(ADDR, H_PAGESIZE * hpages * 2,
			PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE|
			(hugetlb ? MAP_HUGETLB : 0),
			-1, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		exit (1);
	}
	printf("\tgot address %p to %p\n",
		(void *)addr, (void *)(addr + H_PAGESIZE * hpages * 2));

	printf("mmapping %d 2MB huge pages\n", hpages);
	addr = mmap(addr, H_PAGESIZE * hpages, PROT_READ|PROT_WRITE,
			MAP_SHARED|MAP_FIXED|MAP_ANONYMOUS|
			(hugetlb ? MAP_HUGETLB : 0),
			-1, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		exit (1);
	}

	/* initialize data */
	for (i = 0; i < hpages; i++)
		*((char *)addr + (i * H_PAGESIZE)) = 'a'; 

	printf("pages allocated and initialized at %p\n", (void *)addr);

	addr2 = mremap(addr, 0, H_PAGESIZE * hpages,
			MREMAP_MAYMOVE | MREMAP_FIXED,
			addr + (H_PAGESIZE * hpages));
	if (addr2 == MAP_FAILED) {
		perror("mremap");
		exit (1);
	}
	printf("mapping relocated to %p\n", (void *)addr2);

	/* verify data */
	printf("Verifying data at address %p\n", (void *)addr);
	for (i = 0; i < hpages; i++) {
		if (*((char *)addr + (i * H_PAGESIZE)) != 'a') {
			printf("data at address %p not as expected\n",
				(void *)((char *)addr + (i * H_PAGESIZE)));
		}
	}
	if (i >= hpages)
		printf("\t success!\n");

	/* verify data */
	printf("Verifying data at address %p\n", (void *)addr2);
	for (i = 0; i < hpages; i++) {
		if (*((char *)addr2 + (i * H_PAGESIZE)) != 'a') {
			printf("data at address %p not as expected\n",
				(void *)((char *)addr2 + (i * H_PAGESIZE)));
		}
	}
	if (i >= hpages)
		printf("\t success!\n");

	return ret;
}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
