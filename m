From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v3 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Mon, 26 Nov 2018 14:39:15 +0100
Message-ID: <2b0b828a-ce02-b4dc-7f95-d7d1238e40bf@iogearbox.net>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181122140910.1079-1-lmb@cloudflare.com>
 <20181122140910.1079-4-lmb@cloudflare.com>
 <b4308b6f-5a1d-f015-4e7f-abca1b3902be@iogearbox.net>
 <20181124222012.lcc6hn6vr6xbw7zr@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98oSS6qbeNCaqukM81V6vWXdrU2HCp2-b++7E=Xnx7e=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw98oSS6qbeNCaqukM81V6vWXdrU2HCp2-b++7E=Xnx7e=w@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org, linux-api@vger.kernel.org, Y Song <ys114321@gmail.com>
List-Id: linux-api@vger.kernel.org

On 11/26/2018 01:45 PM, Lorenz Bauer wrote:
> On Sat, 24 Nov 2018 at 22:20, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Fri, Nov 23, 2018 at 11:25:11PM +0100, Daniel Borkmann wrote:
>>> On 11/22/2018 03:09 PM, Lorenz Bauer wrote:
[...]
>>>>  LIBBPF_API int bpf_prog_test_run(int prog_fd, int repeat, void *data,
>>>>                              __u32 size, void *data_out, __u32 *size_out,
>>>>                              __u32 *retval, __u32 *duration);
>>>
>>> Could we add a comment into the header here stating that we discourage
>>> bpf_prog_test_run()'s use?
>>>
>>> It would probably also make sense since we go that route that we would
>>> convert the 10 bpf_prog_test_run() instances under test_progs.c at the
>>> same time so that people extending or looking at BPF kselftests don't
>>> copy discouraged bpf_prog_test_run() api as examples from this point
>>> onwards anymore.
>>
>> I would keep bpf_prog_test_run() and test_progs.c as-is.
>> I think the prog_test_run in the current form is actually fine.
>> I don't find it 'unsafe'.
>> When it's called on a given bpf prog the user knows what prog
>> suppose to do. If prog is increasing the packet size the test writer
>> knows that and should size the output buffer accordingly.
> 
> I guess this is a matter of perspective. I prefer an interface that
> gives me back
> an error message, rather than corrupt my stack / heap, when the assumptions
> change. It's also nicer to use from "managed" languages like Go where users
> aren't as accustomed to issues like these.
> 
> Do you object to me adding the disclaimer to the header as Daniel suggested?

Agree that prog_test_run() in the current form is actually fine, I was mostly
thinking that it may be non-obvious to users extending the tests or writing
their own test framework and checking how BPF kselftests does it (since it's
kind of a prime example), so they might end up using the wrong API and run
into mentioned issues w/o realizing. At min some comment with more context
would be needed.

>> Also there are plenty of tests where progs don't change the packet size
>> and any test with 'repeat > 1' should have the packet size
>> return to initial value. Like if the test is doing ipip encap
>> at the end of the run the bpf prog should remove that encap.
>> Otherwise 'repeat > 1' will produce wrong results.
> 
> Yup. Another thorny part of the test interface, which I'd like to improve! :)
> Don't know how to do it yet though.

Yep, somehow here we would need to restore original input packet layout/data
so that the test program always runs on the user defined one.
