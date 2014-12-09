From: Shuah Khan <shuahkhan@gmail.com>
Subject: Re: selftests: question about git repos containing selftest.
Date: Tue, 9 Dec 2014 13:21:01 -0700
Message-ID: <CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141209194602.GB20166@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Young, David" <dayoung@akamai.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 9, 2014 at 12:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 09, 2014 at 02:22:42PM -0500, Young, David wrote:
>> Greetings,
>>
>> I'm trying out the new kernel selftests and was looking for the "bleeding edge" repository to clone.  According to the wiki https://kselftest.wiki.kernel.org/ this is the appropriate repo:
>> git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
>>
>> However, I am finding newer and more frequent changes are in linux-next.
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>
>> Which should I clone for the most fresh changes?
>
> Are you sure you are looking at the correct branch for that git repo?
> Which one were you using?
>

Please find the patches slated for 3.19--rc1 in fixes branch. These
are the ones that
get pulled into linux-next for integration testing.

-- Shuah
