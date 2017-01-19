From: Amir Goldstein <amir73il@gmail.com>
Subject: [LSF/MM TOPIC ATTEND] thawing the fsnotify subsyetm
Date: Thu, 19 Jan 2017 16:28:09 +0200
Message-ID: <CAOQ4uxh9ZbSfO-6V6cYNbNd2eBvVV6MxBCnpSzyp3-zKrYeWWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

My employer has a use case of watching file system changes
over millions of directories.

It so happens that the same product (cloud sync) also runs on
Windows and on MacOS. both OS have a scalable API to monitor
file systems changes over millions of directories.

Since the product requires being notified on filename events
(e.g. create/delete/rename), the only available option on Linux is
inotify, but inotify does not scale well to millions of directories
use case and not a the right tool for the job in general.

For that purpose, I implemented fanotify super block watch [1],
to be able to:
1. report filename events
2. watch over file system root (as opposed to mount point)
3. report event information using struct file_handle,
    instead of keeping open file descriptor per event

Jan Kara has reviewed the high level design and did not
dismiss it.

I was trying to get some cleanup patches through to Al,
but changes to fsnotify that are not bug fixes are not very
popular these days.

I would like to present the suggested solution and make a
case for an API that is a super set of inotify and fanotify,
that will allow users to slowly move to the latter and eventually
to phase out the former.

I would like to discuss with the stake holders how we can
thaw the fsnotify subsystem, to the point that any improvement
can be at least considered.

[1] https://lkml.org/lkml/2016/12/20/312
