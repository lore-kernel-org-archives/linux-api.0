From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/18] io_uring: use fget/fput_many() for file references
Date: Mon, 28 Jan 2019 15:03:49 -0700
Message-ID: <1e235e71-b988-fac1-ea85-9a9d5f70ef5d@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-10-axboe@kernel.dk>
 <CAG48ez0WzBEG5w5faFZ_DjU_62aTT=iBEPHEdYZuyq-LGRJtPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez0WzBEG5w5faFZ_DjU_62aTT=iBEPHEdYZuyq-LGRJtPw@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/28/19 2:56 PM, Jann Horn wrote:
> On Mon, Jan 28, 2019 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>> Add a separate io_submit_state structure, to cache some of the things
>> we need for IO submission.
>>
>> One such example is file reference batching. io_submit_state. We get as
>> many references as the number of sqes we are submitting, and drop
>> unused ones if we end up switching files. The assumption here is that
>> we're usually only dealing with one fd, and if there are multiple,
>> hopefuly they are at least somewhat ordered. Could trivially be extended
>> to cover multiple fds, if needed.
>>
>> On the completion side we do the same thing, except this is trivially
>> done just locally in io_iopoll_reap().
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> [...]
>> +/*
>> + * Get as many references to a file as we have IOs left in this submission,
>> + * assuming most submissions are for one file, or at least that each file
>> + * has more than one submission.
>> + */
>> +static struct file *io_file_get(struct io_submit_state *state, int fd)
>> +{
>> +       if (!state)
>> +               return fget(fd);
>> +
>> +       if (state->file) {
>> +               if (state->fd == fd) {
>> +                       state->used_refs++;
>> +                       state->ios_left--;
>> +                       return state->file;
>> +               }
>> +               io_file_put(state, NULL);
>> +       }
>> +       state->file = fget_many(fd, state->ios_left);
>> +       if (!state->file)
>> +               return NULL;
> 
> This looks wrong.
> 
> Looking at "[PATCH 05/18] Add io_uring IO interface", as far as I can
> tell, io_ring_submit() is called via __io_uring_enter() <-
> sys_io_uring_enter() with an unchecked argument "unsigned int
> to_submit" that is then, in this patch, stored in state->ios_left and
> then used here. On a 32-bit platform, file->f_count is only 32 bits
> wide, so I think you can then trivially overflow the reference count,
> leading to use-after-free. Am I missing something?

No, that is possible. Since we cap the SQ ring entries at 4k, I think
we should just validate to_submit/min_complete against those numbers.
That would also solve this overflow.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
