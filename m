From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 1/9] fs: add fcntl() interface for setting/getting write
 life time hints
Date: Mon, 26 Jun 2017 10:29:53 -0600
Message-ID: <ba179e93-7e34-d45b-0913-309efd458f60@kernel.dk>
References: <1498004526-4543-1-git-send-email-axboe@kernel.dk>
 <1498004526-4543-2-git-send-email-axboe@kernel.dk>
 <20170626095148.GB14057@infradead.org>
 <91b3fd3b-18f5-cf8c-a1d7-c0637283ce14@kernel.dk>
 <20170626160946.GI3787@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626160946.GI3787-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/26/2017 10:09 AM, Darrick J. Wong wrote:
> On Mon, Jun 26, 2017 at 07:55:27AM -0600, Jens Axboe wrote:
>> On 06/26/2017 03:51 AM, Christoph Hellwig wrote:
>>> Please document the userspace API (added linux-api and linux-man
>>> to CC for sugestions), especially including the odd effects of the
>>> per-inode settings.
>>
>> Of course, I'll send in a diff for the fcntl(2) man page.
>>
>>> Also I would highly recommend to use different fcntl commands
>>> for the file vs inode hints to avoid any strange behavior.
>>
>> OK, used to have that too... I can add specific _FILE versions.
> 
> While you're at it, can you also send in an xfstest or two to check the
> basic functionality of the fcntl so that we know the code reflects the
> userspace API ("I set this hint and now I can query it back" and "file
> hint overrides inode hint") that we want?

I definitely can. I already wrote the below to verify that it behaves
the way it should.


/*
 * test-writehints.c: test file/inode write hint setting/getting
 */
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <inttypes.h>
#include <assert.h>

#ifndef F_GET_RW_HINT
#define F_LINUX_SPECIFIC_BASE	1024
#define F_GET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 11)
#define F_SET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 12)
#define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
#define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)

#define RWF_WRITE_LIFE_NOT_SET	0
#define RWH_WRITE_LIFE_NONE	1
#define RWH_WRITE_LIFE_SHORT	2
#define RWH_WRITE_LIFE_MEDIUM	3
#define RWH_WRITE_LIFE_LONG	4
#define RWH_WRITE_LIFE_EXTREME	5

#endif

static int __get_write_hint(int fd, int cmd)
{
	uint64_t hint;
	int ret;

	ret = fcntl(fd, cmd, &hint);
	if (ret < 0) {
		perror("fcntl: F_GET_RW_FILE_HINT");
		return -1;
	}

	return hint;
}

static int get_file_write_hint(int fd)
{
	return __get_write_hint(fd, F_GET_FILE_RW_HINT);
}

static int get_inode_write_hint(int fd)
{
	return __get_write_hint(fd, F_GET_RW_HINT);
}

static void set_file_write_hint(int fd, uint64_t hint)
{
	uint64_t set_hint = hint;
	int ret;

	ret = fcntl(fd, F_SET_FILE_RW_HINT, &set_hint);
	if (ret < 0) {
		perror("fcntl: F_RW_SET_HINT");
		return;
	}
}

static void set_inode_write_hint(int fd, uint64_t hint)
{
	uint64_t set_hint = hint;
	int ret;

	ret = fcntl(fd, F_SET_RW_HINT, &set_hint);
	if (ret < 0) {
		perror("fcntl: F_RW_SET_HINT");
		return;
	}
}

int main(int argc, char *argv[])
{
	char filename[] = "/tmp/writehintsXXXXXX";
	int ihint, fhint, fd;

	fd = open(filename, O_RDWR | O_CREAT | 0644);
	if (fd < 0) {
		perror("open");
		return 2;
	}

	/*
	 * Default hints for both file and inode should be NOT_SET
	 */
	fhint = get_file_write_hint(fd);
	if (fhint < 0)
		return 0;
	ihint = get_inode_write_hint(fd);
	assert(fhint == ihint);
	assert(fhint == RWF_WRITE_LIFE_NOT_SET);

	/*
	 * Set inode hint, check file hint returns the right hint
	 */
	set_inode_write_hint(fd, RWH_WRITE_LIFE_SHORT);
	fhint = get_file_write_hint(fd);
	ihint = get_inode_write_hint(fd);
	assert(fhint == ihint);
	assert(fhint == RWH_WRITE_LIFE_SHORT);

	/*
	 * Now set file hint, ensure that this is now the hint we get
	 */
	set_file_write_hint(fd, RWH_WRITE_LIFE_LONG);
	fhint = get_file_write_hint(fd);
	ihint = get_inode_write_hint(fd);
	assert(fhint == RWH_WRITE_LIFE_LONG);
	assert(ihint == RWH_WRITE_LIFE_SHORT);

	/*
	 * Clear inode write hint, ensure that file still returns the set hint
	 */
	set_inode_write_hint(fd, RWF_WRITE_LIFE_NOT_SET);
	fhint = get_file_write_hint(fd);
	ihint = get_inode_write_hint(fd);
	assert(fhint == RWH_WRITE_LIFE_LONG);
	assert(ihint == RWF_WRITE_LIFE_NOT_SET);

	/*
	 * Clear file write hint, ensure that now returns cleared
	 */
	set_file_write_hint(fd, RWF_WRITE_LIFE_NOT_SET);
	fhint = get_file_write_hint(fd);
	assert(fhint == RWF_WRITE_LIFE_NOT_SET);

	close(fd);
	unlink(filename);
	return 0;
}


-- 
Jens Axboe
