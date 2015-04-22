From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] Test compaction of mlocked memory
Date: Wed, 22 Apr 2015 14:16:35 -0700
Message-ID: <20150422141635.e8e31a717ebc608d4d5b14c6@linux-foundation.org>
References: <1429736480-8017-1-git-send-email-sjayaram@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429736480-8017-1-git-send-email-sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Apr 2015 17:01:20 -0400 Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> Commit commit 5bbe3547aa3b ("mm: allow compaction of unevictable pages")
> introduced a sysctl that allows userspace to enable scanning of locked
> pages for compaction.  This patch introduces a new test which fragments
> main memory and attempts to allocate a number of huge pages to exercise
> this compaction logic.
> 
> Tested on machines with up to 32 GB RAM. With the patch a much larger
> number of huge pages can be allocated than on the kernel without the patch.

Looks nice.  It would be very helpful to include example output in the
changelog.  It helps people understand what the test is doing, how it
reports on it, etc.

> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -2,7 +2,7 @@
>  
>  CFLAGS = -Wall
>  BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
> -BINARIES += transhuge-stress
> +BINARIES += transhuge-stress compaction_test

While you're in there I suggest you switch BINARIES to one value per
line:

BINARIES = hugepage-mmap
BINARIES += hugepage-shm
...

This makes patch merging and maintenance easier.  Also, keeping the
list alphasorted reduces the chance of patch collisions.  Otherwise
everyone adds at the end, which maximises the chance of collisions :(


> ...
>
> +int prereq(void)
> +{
> +	char allowed;
> +	int fd;
> +
> +	fd = open("/proc/sys/vm/compact_unevictable_allowed",
> +		  O_RDONLY | O_NONBLOCK);
> +	if (fd < 0) {
> +		perror("Failed to open\n"
> +		       "/proc/sys/vm/compact_unevictable_allowed\n");
> +		return -1;
> +	}
> +	
> +	if (read(fd, &allowed, sizeof(char)) < 0) {

	if (read(fd, &allowed, sizeof(char)) != sizeof(char)) {

(this change should be made in multiple places).

> +		perror("Failed to read from\n"
> +		       "/proc/sys/vm/compact_unevictable_allowed\n");
> +		close(fd);
> +		return -1;
> +	}
> +	
> +	close(fd);
> +	if (allowed == '1')
> +		return 0;
> +	
> +	return -1;
> +}
> +
> +int check_compaction(unsigned long mem_free, unsigned int hugepage_size)  
> +{
> +	int fd;
> +	int compaction_index = 0;
> +	char initail_nr_hugepages[10] = {0};

"initial"

> +	char nr_hugepages[10] = {0};
> +	
> +	/* We want to test with 80% available memory. Else, OOM killer comes in
> +	   to play */
> +	mem_free = mem_free * 0.8;
> +	
> +	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
> +	if (fd < 0) {
> +		perror("Failed to open /proc/sys/vm/nr_hugepages");
> +		return -1;
> +	}
> +	
> +	if (read(fd, initail_nr_hugepages, sizeof(initail_nr_hugepages)) < 0) {
> +		perror("Failed to read from /proc/sys/vm/nr_hugepages");
> +		goto close_fd;
> +	}
> +	
> +	/* Start with the initial condition of 0 huge pages*/
> +	if (write(fd, "0", 1) < 0) {

!= 1.

> +		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
> +		goto close_fd;
> +	}
> +	
> +	lseek(fd, 0, SEEK_SET);
> +	
> +	/* Request a large number of huge pages. The Kernel will allocate
> +	   as much as it can */
> +	if (write(fd, "100000", 6) < 0) {
> +		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
> +		goto close_fd;
> +	}
> +	
> +	lseek(fd, 0, SEEK_SET);
> +	
> +	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) < 0) {
> +		perror("Failed to read from /proc/sys/vm/nr_hugepages\n");
> +		goto close_fd;
> +	}
> +	
> +	/* We should have been able to request at least 1/4 th of the memory in
> +	   huge pages */
> +	compaction_index = mem_free/(atoi(nr_hugepages) * hugepage_size);
> +	
> +	if (compaction_index > 4) {
> +		fprintf(stderr, "ERROR: Less that 1/%d of memory is available\n"
> +			"as huge pages\n", compaction_index);
> +		goto close_fd;
> +	}
> +	
> +	if (write(fd, initail_nr_hugepages, sizeof(initail_nr_hugepages)) < 0) {
> +		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
> +		goto close_fd;
> +	}
> +	
> +	close(fd);
> +	return 0;
> +	
> + close_fd:
> +	close(fd);
> +	printf("Not OK. Compaction test failed.");
> +	return -1;
> +}
> ...
>
