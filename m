From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 17:34:21 +0300
Message-ID: <1f7cafc5-1969-1c6d-6fb1-441854d60fcb@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
 <6ebe1e2f-77f4-ae88-e184-c140a911cbd8@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6ebe1e2f-77f4-ae88-e184-c140a911cbd8-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/29/2020 5:27 PM, Stefan Metzmacher wrote:
>> Great, that you turned attention to that! override_creds() is already
>> grabbing a ref, so it shouldn't call get_cred() there.
>> So, that's a bug.
>>
>> It could be I'm wrong with the statement above, need to recheck all this
>> code to be sure.
>>
>> BTW, io_req_defer_prep() may be called twice for a req, so you will
>> reassign it without putting a ref. It's safer to leave NULL checks. At
>> least, until I've done reworking and fixing preparation paths.
> 
> Ok, but that would be already a bug in
> "io_uring/io-wq: don't use static creds/mm assignments"
> instead of logically being part of
> "io_uring: support using a registered personality for commands"

Right. Probably should be backported there, since it's just 2 commits
before.

-- 
Pavel Begunkov
