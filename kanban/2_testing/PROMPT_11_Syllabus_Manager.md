# GWTH Pipeline V2

**Syllabus Manager**

The Syllabus Manager is all about the UI as I will manually work out the syllabus and move the lessons about until I’m happy with the order. Also in the future as I add new lessons I need to easily fink the correct place / order for new or updated lessons. Currently the UI is not helpful. I have the following requirements:**

1. I use an enormous screen which is 4K and 32 inches diagonally. The current UI is not optimised for such a large screen. 
2. I want to use the entire screen to manage the syllabus with the columns taking most of the screen. I don't want click on the L to see more lessons I want to see all of the lessons in one place
3. I want to be able to quickly drag and drop lessons from one place to another and from one column to another e.g. backlog to place 5 in Month 1.
4. I want to see the following data in each lesson box - title, position in syllabus, short description, Project title. If a lesson then gets changed in the Lesson Writer tab the changes should be reflected in the Syllabus Manager tab.
5. Each lesson box should be expandable so I can see all the info and click on a button to Edit Lesson which takes me to the Lesson Writer tab.

I want to have enough info in each lesson box for claude to use the lesson writer skill to automatically generate the lesson in the Lesson Writer tab. If you think I have missed anything please tell me.

Please think ultra hard and make a plan. Ask any questions and make any suggestions where you think there is a better way to achieve the plan. Then list all the tasks you need to do. 

Once you have a plan and tasks Run a Ralph loop on P520 with max 5 iterations:

1. Write acceptance tests including ones that leverage the Chrome extension's ability to actually see the page, read console errors, and interact with elements making it a true automated testing loop.
2. Write the code
3. Check the UI matches your plan
4. Run the tests

Completion: All tests pass

Don’t let the context window go over 120k/200k. As it gets close please run a compact so you are always running optimally.
