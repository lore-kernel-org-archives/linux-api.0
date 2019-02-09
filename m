From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/19] io_uring: add support for pre-mapped user IO
 buffers
Date: Sat, 9 Feb 2019 09:50:04 -0700
Message-ID: <7cb5df70-1179-c566-7c13-31e96c32d66b@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-13-axboe@kernel.dk>
 <CAG48ez0uH_muHobzpwFzdyBWCcWDxbnfpuxABntph6Te+tYxGg@mail.gmail.com>
 <2ef04b12-6a4b-af25-cbf8-9dde79b0ec1e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <2ef04b12-6a4b-af25-cbf8-9dde79b0ec1e@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 2/8/19 4:38 PM, Jens Axboe wrote:
>> Technically, this accounting is probably a bit off; I think if you
>> pass in a vector of 4K areas from 1G hugepages, you're going to pin
>> factor 0x40000 more memory than you think you're pinning.
>> (get_user_pages() counts references against the head page of a
>> compound page; nothing in the kernel can tell afterwards which part of
>> the hugepage you're using.) I'm not sure how much of a problem that
>> is, but it should probably at least be documented. Unless I'm just
>> missing something?
> 
> No I think you are right, it doesn't account for the hugepage size if
> you pass in huge pages. I'll fix that up.

I made a note of it in the man page, I don't think this is unreasonable
(or unexpected) behavior.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
