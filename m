From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 10:07:43 +0100
Message-ID: <54BF6C5F.9080008@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com> <54BE957A.60305@zonque.org> <54BF6A13.2090008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54BF6A13.2090008@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 01/21/2015 09:57 AM, Michael Kerrisk (man-pages) wrote:
> On 01/20/2015 06:50 PM, Daniel Mack wrote:

>> I've addressed all but the below issues, following your suggestions.
> 
> Are your changes already visible somewhere?

Yes, in the upstream repo for the standalone module, which we also use
to build the patch set from:

  https://code.google.com/p/d-bus/source/browse/kdbus.txt

>> Hmm, you're quoting text from section 5, and section 4 actually
>> describes the concept of items quite well I believe?
> 
> Well, Section 4 is pretty short. My point is that most of the various 
> blob formats (e.g., kdbus_pids, kdbus_caps, kdbus_memfd) are not
> documented in kdbus.txt. They all should be, IMO.

Okay, I'll add some text about them.


Best regards,
Daniel
