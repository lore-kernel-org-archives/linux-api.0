From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/18] io_uring: use fget/fput_many() for file references
Date: Wed, 30 Jan 2019 08:33:52 -0700
Message-ID: <c0fd9a4c-e2ce-fa17-da95-a32b688f0ae0@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-10-axboe@kernel.dk>
 <CAG48ez3_1mY1Fb91Q3H-S2+4OiMsV5F9v78JX+YMjWqLteHpzw@mail.gmail.com>
 <bceb5e2b-9634-1296-a2a9-ed521f0e31d4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <bceb5e2b-9634-1296-a2a9-ed521f0e31d4@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 4:44 PM, Jens Axboe wrote:
> On 1/29/19 4:31 PM, Jann Horn wrote:
>> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> Add a separate io_submit_state structure, to cache some of the things
>>> we need for IO submission.
>>>
>>> One such example is file reference batching. io_submit_state. We get as
>>> many references as the number of sqes we are submitting, and drop
>>> unused ones if we end up switching files. The assumption here is that
>>> we're usually only dealing with one fd, and if there are multiple,
>>> hopefuly they are at least somewhat ordered. Could trivially be extended
>>> to cover multiple fds, if needed.
>>>
>>> On the completion side we do the same thing, except this is trivially
>>> done just locally in io_iopoll_reap().
>> [...]
>>> +static void io_file_put(struct io_submit_state *state, struct file *file)
>>> +{
>>> +       if (!state) {
>>> +               fput(file);
>>> +       } else if (state->file) {
>>> +               int diff = state->has_refs - state->used_refs;
>>> +
>>> +               if (diff)
>>> +                       fput_many(state->file, diff);
>>> +               state->file = NULL;
>>> +       }
>>> +}
>>
>> Hmm, this function confuses me.
>> The state==NULL path works as I'd expect, it calls fput() on the file.
>> But if `state!=NULL && state->file==NULL`, it does nothing, it never
>> uses `file`.
>> And if `state->file!=NULL`, it drops the excess bias on the file's
>> refcount, but it doesn't drop the current reference - and again
>> without even looking at `file`.
>>
>> So when io_prep_rw() uses io_file_get() to grab a reference on a file
>> it hasn't seen before, it will acquire `ios_left` references and
>> actually use one of them; then if it goes through the out_fput error
>> path, it goes through the path for `state->file!=NULL`, drops
>> `ios_left-1` references (leaving the refcount elevated by 1), and
>> forgets about the file?
> 
> I'll take a look, it's not impossible there's an off-by-one there.

Fixed it!

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
